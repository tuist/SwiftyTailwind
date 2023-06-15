import Foundation
import OSLog
import SwiftCPUDetect
import TSCBasic

/*
 An enum that represents the various errors that the `Downloader` can throw.
 */
enum DownloaderError: LocalizedError {
    /**
     This error is thrown when the binary name cannot be determined.
     */
    case unableToDetermineBinaryName
    
    var errorDescription: String? {
        switch self {
        case .unableToDetermineBinaryName:
            return "We were unable to determine Tailwind's binary name for this architecture and OS."
        }
    }
}

protocol Downloading {
    /**
     It downloads the latest version of Tailwind in a default directory.
     */
    func download() async throws -> AbsolutePath
    /**
     It downloads the given version of Tailwind in the given directory.
     */
    func download(version: TailwindVersion, directory: AbsolutePath) async throws -> AbsolutePath
}

class Downloader: Downloading {
    let architectureDetector: ArchitectureDetecting
    let logger: Logger
    
    /**
     Returns the default directory where Tailwind binaries should be downloaded.
     */
    static func defaultDownloadDirectory() -> AbsolutePath {
        return try! localFileSystem.tempDirectory.appending(component: "SwiftyTailwind")
    }
    
    init(architectureDetector: ArchitectureDetecting = ArchitectureDetector()) {
        self.architectureDetector = architectureDetector
        self.logger = Logger(subsystem: "me.pepicrft.SwiftyTailwind", category: "Downloader")
    }
    
    func download() async throws -> TSCBasic.AbsolutePath {
        try await download(version: .latest, directory: Downloader.defaultDownloadDirectory())
    }
    
    func download(version: TailwindVersion,
                  directory: AbsolutePath) async throws -> AbsolutePath
    {
        guard let binaryName = binaryName() else {
            throw DownloaderError.unableToDetermineBinaryName
        }
        let expectedVersion = await versionToDownload(version: version)
        let binaryPath = directory.appending(components: [expectedVersion, binaryName])
        if localFileSystem.exists(binaryPath) { return binaryPath }
        try await downloadBinary(name: binaryName, version: expectedVersion, to: binaryPath)
        return binaryPath
    }
    
    private func downloadBinary(name: String, version: String, to downloadPath: AbsolutePath) async throws {
        if !localFileSystem.exists(downloadPath.parentDirectory) {
            logger.debug("Creating directory \(downloadPath.parentDirectory)")
            try localFileSystem.createDirectory(downloadPath.parentDirectory, recursive: true)
        }
        let url = URL(string: "https://github.com/tailwindlabs/tailwindcss/releases/download/\(version)/\(name)")!
        logger.debug("Downloading binary \(name) from version \(version)...")
        let (localURL, _) = try await URLSession.shared.download(from: url)
        let localPath = try! AbsolutePath(validating: localURL.path())
        logger.debug("Giving the binary executable permissions")
        try localFileSystem.chmod(.executable, path: localPath)
        logger.debug("Moving the binary to the final destination")
        try localFileSystem.copy(from: localPath, to: downloadPath)
    }
    
    /**
     Returns the version that should be downloaded.
     */
    private func versionToDownload(version: TailwindVersion) async -> String {
        switch version {
        case .fixed(let rawVersion):
            if rawVersion.starts(with: "v") {
                return rawVersion
            } else {
                /**
                 Releases on GitHub are prefixed with "v" so we need to include it.
                 */
                return "v\(rawVersion)"
            }
        case .latest: return await latestVersion()
        }
    }
    
    /**
     It obtains the latest available release from GitHub releases
     */
    private func latestVersion() async -> String {
        let latestReleaseURL = URL(string: "https://api.github.com/repos/tailwindlabs/tailwindcss/releases/latest")!
        logger.debug("Getting the latest Tailwind version from \(latestReleaseURL)")
        let (data, _) = try! await URLSession.shared.data(from: latestReleaseURL)
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        let tagName = json["tag_name"] as! String
        logger.debug("The latest Tailwind version available is \(tagName)")
        return tagName
    }
    
    /**
        It returns the name of the artifact that we should pull from the GitHub release. The artifact follows the convention: tailwindcss-{os}-{arch}
     */
    private func binaryName() -> String? {
        guard let architecture = architectureDetector.architecture(), let tailwindArchitecture = architecture.tailwindCPUIdentifier() else {
            return nil
        }
        var os: String!
        var ext: String! = ""
        #if os(Windows)
        os = "windows"
        ext = ".exe"
        #elseif os(Linux)
        os = "linux"
        #else
        os = "macos"
        #endif
        return "tailwindcss-\(os as String)-\(tailwindArchitecture)\(ext as String)"
    }
}

private extension CpuArchitecture {
    /**
        It maps the ``CpuArchitecture`` enum to the value used by Tailwind when uploading their artifacts to GitHub releases.
     */
    func tailwindCPUIdentifier() -> String? {
        switch self {
        case .arm64: return "arm64"
        case .intel64: return "x64"
        default: return nil
        }
    }
}

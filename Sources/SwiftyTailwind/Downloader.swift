import Foundation
import TSCBasic
import SwiftCPUDetect

protocol Downloading {
    
}

class Downloader: Downloading {
    let architectureDetector: ArchitectureDetecting
    
    init(architectureDetector: ArchitectureDetecting) {
        self.architectureDetector = architectureDetector
    }
    
    func download(version: TailwindVersion = .latest) async {
        
    }
    
    static func defaultDownloadDirectory() -> AbsolutePath {
        TemporaryFile
    }
    
    /**
        It returns the name of the artifact that we should pull from the GitHub release. The artifact follows the convention: tailwindcss-{os}-{arch}
     */
    private func binaryName() -> String? {
        guard let architecture = self.architectureDetector.architecture(), let tailwindArchitecture = architecture.tailwindCPUIdentifier() else {
            return nil
        }
        var os: String!
        #if os(Windows)
        os = "windows"
        #elseif os(Linux)
        os = "linux"
        #else
        os = "macos"
        #endif
        return "tailwindcss-\(String(describing: os))-\(tailwindArchitecture)"
    }
}

private extension CpuArchitecture {
    /**
        It maps the CpuArchitecture enum to the value used by Tailwind when uploading their artifacts to GitHub releases.
     */
    func tailwindCPUIdentifier() -> String? {
        switch self {
        case .arm64: return "arm64"
        case .intel64: return "x64"
        default: return nil
        }
    }
}

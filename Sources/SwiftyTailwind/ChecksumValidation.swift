import Foundation
import TSCBasic

protocol ChecksumValidating {
    func generateChecksumFrom(_ filePath: AbsolutePath) throws -> String
    func compareChecksum(from filePath: AbsolutePath, to checksum: String) throws -> Bool
}

struct ChecksumValidation: ChecksumValidating {
    func generateChecksumFrom(_ filePath: AbsolutePath) throws -> String {
        let checksumGenerationTask = Process()
        checksumGenerationTask.launchPath = "shasum"
        checksumGenerationTask.arguments = ["-a", "256", filePath.pathString]
        
        let pipe = Pipe()
        checksumGenerationTask.standardOutput = pipe
        checksumGenerationTask.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: String.Encoding.utf8) else {
            throw DownloaderError.errorReadingFilesForChecksumValidation
        }
        
        return output
    }
    
    func compareChecksum(from filePath: AbsolutePath, to checksum: String) throws -> Bool {
        let checksumString = try String(contentsOf: filePath.asURL)
        return checksum == checksumString
    }
}

import Foundation
import TSCBasic

protocol Executing {
    func run(executablePath: AbsolutePath, directory: AbsolutePath, arguments: [String]) async throws
}

class Executor: Executing {
    func run(executablePath: TSCBasic.AbsolutePath, directory: AbsolutePath, arguments: [String]) async throws {
        
    }
}

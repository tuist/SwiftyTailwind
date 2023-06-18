import Foundation
import TSCBasic
import Logging

/**
 Executing describes the interface to run system processes. Executors are used by `SwiftyTailwind` to run the Tailwind executable using system processes.
 */
protocol Executing {
    /**
     Runs a system process using the given executable path and arguments.
     - Parameters:
        - executablePath: The absolute path to the executable to run.
        - directory: The working directory from to run the executable.
        - arguments: The arguments to pass to the executable.
     */
    func run(executablePath: AbsolutePath,
             directory: AbsolutePath,
             arguments: [String]) async throws
}

class Executor: Executing {
    
    let logger: Logger
    
    /**
     Creates a new instance of `Executor`
     */
    init() {
        self.logger = Logger(label: "me.pepicrft.SwiftyTailwind.Executor")
    }
    
    func run(executablePath: TSCBasic.AbsolutePath, directory: AbsolutePath, arguments: [String]) async throws {
        let arguments = [executablePath.pathString] + arguments
        logger.debug("Running: \(arguments.joined(separator: " "))")
        let process = Process(arguments: arguments,
                              workingDirectory: directory,
                              outputRedirection: .stream(stdout: { [weak self] output in
            if let outputString = String.init(bytes: output, encoding: .utf8) {
                self?.logger.debug("\(outputString)")
            }
        }, stderr: { [weak self] error in
            if let errorString = String.init(bytes: error, encoding: .utf8) {
                self?.logger.error("\(errorString)")
            }
            
        }))
        try process.launch()
        try await process.waitUntilExit()
    }
}

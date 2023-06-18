import TSCBasic

/**
 This class is the main interface to download and run [Tailwind](https://tailwindcss.com) from a Swift project. Every function of the interface we'll lazily download a portable Tailwind executable, which includes the [NodeJS](https://nodejs.org/en) runtime, and invoke it using system processes.
 */
public class SwiftyTailwind {
    private let version: TailwindVersion
    private let directory: AbsolutePath
    private let downloader: Downloading
    private let executor: Executing
    
    /**
     Default initializer.
     - Parameters:
     - version: The version of Tailwind to use. You can specify a fixed version or use the latest one.
     - directory: The directory where the executables will be downloaded. When not provided, it defaults to the system's default temporary directory.
     */
    public convenience init(version: TailwindVersion = .latest, directory: AbsolutePath) {
        self.init(version: version, directory: directory, downloader: Downloader(), executor: Executor())
    }
    
    /**
     Default initializer.
     - Parameters:
     - version: The version of Tailwind to use. You can specify a fixed version or use the latest one.
     */
    public convenience init(version: TailwindVersion = .latest) {
        self.init(version: version, directory: Downloader.defaultDownloadDirectory(), downloader: Downloader(), executor: Executor())
    }
    
    init(version: TailwindVersion,
         directory: AbsolutePath,
         downloader: Downloading,
         executor: Executing)
    {
        self.version = version
        self.directory = directory
        self.downloader = downloader
        self.executor = executor
    }
    
    /**
     It runs the `init` command to create a Tailwind configuration file (i.e., `tailwind.config.js`)
     - Parameters:
     - directory: The directory in which the Tailwind configuration will be created. When not passed, it defaults to the working directory from where the process is running.
     - options: A set of ``SwiftyTailwind.InitializeOption`` options to customize the initialization.
     */
    public func initialize(directory: AbsolutePath = localFileSystem.currentWorkingDirectory!,
                           options: InitializeOption...) async throws
    {
        var arguments = ["init"]
        arguments.append(contentsOf: Set(options).executableFlags)
        let executablePath = try await download()
        try await executor.run(executablePath: executablePath, directory: directory, arguments: arguments)
    }
    
    /**
     It runs the main Tailwind command.
     - Parameters:
     - directory: The directory from where to run the command. When not passed, it defaults to the working directory from where the process is running.
     - options: A set of ``SwiftyTailwind.RunOption`` options to customize the execution.
     */
    public func run(input: AbsolutePath,
                    output: AbsolutePath,
                    directory: AbsolutePath = localFileSystem.currentWorkingDirectory!,
                    options: RunOption...) async throws {
        var arguments: [String] = [
            "--input", input.pathString,
            "--output", output.pathString
        ]
        arguments.append(contentsOf: Set(options).executableFlags)
        if (!options.contains(.autoPrefixer)) { arguments.append("--no-autoprefixer")}
        let executablePath = try await download()
        try await executor.run(executablePath: executablePath, directory: directory, arguments: arguments)
    }
    
    /**
     Downloads the Tailwind portable executable
     */
    private func download() async throws -> AbsolutePath {
        try await downloader.download(version: version, directory: directory)
    }
}

extension Set where Element == SwiftyTailwind.InitializeOption {
    /**
     Returns the flags to pass to the Tailwind CLI when invoking the `init` command.
     */
    var executableFlags: [String] {
        return self.map(\.flag)
    }
}

extension Set where Element == SwiftyTailwind.RunOption {
    /**
     Returns the flags to pass to the Tailwind CLI when invoking the `init` command.
     */
    var executableFlags: [String] {
        return self.map(\.flag).flatMap({$0})
    }
}

public extension SwiftyTailwind {
    enum InitializeOption: Hashable {
        /**
         Initializes configuration file as ESM. When passed, it passes the `--esm` flag to the `init` command.
         */
        case esm
        
        /**
         Initializes configuration file as Typescript. When passed, it passes the `--ts` flag to the `init` command.
         */
        case ts
        
        /**
         Initializes a `postcss.config.js` file. When passed, it passes the `--postcss` flag to the `init` command.
         */
        case postcss
        
        /**
         Includes the default values for all options in the generated configuration file. When passed, it passes the `--full` flag to the `init` command.
         */
        case full
        
        /**
         The CLI flag that represents the option.
         */
        var flag: String {
            switch self {
            case .esm: return "--esm"
            case .ts: return "--ts"
            case .postcss: return "--postcss"
            case .full: return "--full"
            }
        }
    }
    
    /**
     An enum that captures all the options that that you can pass to the Tailwind executable.
     */
    enum RunOption: Hashable {
        /**
         Keeps the process running watching for file changes. When passed, it passes the `--watch` argument to the Tailwind executable.
         */
        case watch
        
        /**
         It uses polling to watch file changes. When passed, it passes the `--poll` argument to the Tailwind executable.
         */
        case poll
        
        /**
         It enables [auto-prefixer](https://github.com/postcss/autoprefixer). When passed, it doesn't pass the `--no-autoprefixer` variable.
         */
        case autoPrefixer
        
        /**
         It  minifies the generated output CSS. When passed, it passes the `--minify` argument to the Tailwind executable.
         */
        case minify
        /**
         It uses a configuration other than the one in the current working directory. When passed, it passes the `--config` argument to the Tailwind executable.
         */
        case config(AbsolutePath)
        
        /**
         It runs PostCSS using the configuration file at the given path. When passed, it passes the `--postcss` argument to the Tailwind executable.
         */
        case postcss(AbsolutePath)
        
        /**
         It specifies a [glob](https://en.wikipedia.org/wiki/Glob_(programming)) pattern that the Tailwind executable uses to to tree-shake the output CSS eliminating the Tailwind classes that are not used. When passed, it passes the `--content` argument to the Tailwind executable.
         */
        case content(String)
        
        /**
         The CLI flag that represents the option.
         */
        var flag: [String] {
            switch self {
            case .watch:
                return ["--watch"]
            case .poll:
                return ["--poll"]
            case .autoPrefixer:
                return []
            case .minify:
                return ["--minify"]
            case .config(let path):
                return ["--config", path.pathString]
            case .postcss(let path):
                return ["--postcss", path.pathString]
            case .content(let content):
                return ["--content", content]
            }
        }
    }
}

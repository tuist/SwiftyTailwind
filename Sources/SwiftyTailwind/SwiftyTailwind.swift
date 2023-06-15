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
    convenience init(version: TailwindVersion = .latest, directory: AbsolutePath = Downloader.defaultDownloadDirectory()) {
        self.init(version: version, directory: directory, downloader: Downloader(), executor: Executor())
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
    
    public func run(options: Set<Options>) async throws {
        //    tailwindcss [--input input.css] [--output output.css] [--watch] [options...]
        let executablePath = try await download()
//        try await executor.run(executablePath: executablePath, arguments: [])
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
        return []
    }
}

public extension SwiftyTailwind {
    enum InitializeOption: Hashable {
        /**
         Initialize configuration file as ESM. When passed, it passes the `--esm` flag to the `init` command.
         */
        case esm
        
        /**
         Initialize configuration file as Typescript. When passed, it passes the `--ts` flag to the `init` command.
         */
        case ts
        
        /**
         Initialize a `postcss.config.js` file. When passed, it passes the `--postcss` flag to the `init` command.
         */
        case postcss
        
        /**
         Include the default values for all options in the generated configuration file. When passed, it passes the `--full` flag to the `init` command.
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
    
    enum Options: Hashable {
        case minify
        /**
         Absolute path to the configuration file
         */
        case config(AbsolutePath)
        
//    Options:
//        -i, --input              Input file
//        -o, --output             Output file
//        -w, --watch              Watch for changes and rebuild as needed
//            -p, --poll               Use polling instead of filesystem events when watching
//            --content            Content paths to use for removing unused classes
//                --postcss            Load custom PostCSS configuration
//                -c, --config             Path to a custom config file
//                --no-autoprefixer    Disable autoprefixer
//                -h, --help               Display usage information
    }
}

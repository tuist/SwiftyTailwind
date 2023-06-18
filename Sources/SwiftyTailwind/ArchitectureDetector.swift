import Foundation
import TSCBasic
import TSCUtility

public enum CpuArchitecture: String, Hashable  {
    case arm64   = "arm64"
    case armv7   = "armv7"
    case x64   = "x64"
}

/**
 A protocol that declares an interface to obtain the CPU architecture of the environment in which the program is running.
 */
protocol ArchitectureDetecting {
    /**
        It returns the architecture if it can be obtained and nil otherwise.
     */
    func architecture() -> CpuArchitecture?
}

class ArchitectureDetector: ArchitectureDetecting {
    func architecture() -> CpuArchitecture? {
        let process = Process(arguments: ["uname", "-m"], outputRedirection: .collect)
        _ = try? process.launch()
        let result = try? process.waitUntilExit()
        let output = try? result?.utf8Output().spm_chomp()
        print("YOLO \(output)")
        return CpuArchitecture(rawValue: output ?? "")
    }
}

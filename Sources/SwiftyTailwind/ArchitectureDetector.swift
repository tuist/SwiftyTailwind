import Foundation
import SwiftCPUDetect

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
        return CpuArchitecture.current()
    }
}

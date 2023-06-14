import Foundation
import XCTest
@testable import SwiftyTailwind

final class ArchitectureDetectorTests: XCTestCase {
    var subject: ArchitectureDetector!
    
    override func setUp() {
        super.setUp()
        subject = ArchitectureDetector()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func test_architecture() {
        XCTAssertNotNil(subject.architecture())
    }
}

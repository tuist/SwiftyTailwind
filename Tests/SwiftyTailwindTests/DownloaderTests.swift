import Foundation
import XCTest
import TSCBasic

@testable import SwiftyTailwind

final class DownloaderTests: XCTestCase {
    var subject: Downloader!
    
    override func setUp() {
        super.setUp()
        subject = Downloader()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    func test_download() async throws {
        _ = try await withTemporaryDirectory { tmpDirectory in
            try await subject.download(version: .latest, directory: tmpDirectory)
        }
    }
}

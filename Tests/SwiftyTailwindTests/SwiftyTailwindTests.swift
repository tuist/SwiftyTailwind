import XCTest
import TSCBasic
@testable import SwiftyTailwind

final class SwiftyTailwindTests: XCTestCase {
    func test_initialize() async throws {
        try await withTemporaryDirectory(removeTreeOnDeinit: true, { tmpDir in
            // Given
            let subject = SwiftyTailwind(directory: tmpDir)
            
            // When
            try await subject.initialize(directory: tmpDir, options: .full)
            
            // Then
            let tailwindConfigPath = tmpDir.appending(component: "tailwind.config.js")
            XCTAssertTrue(localFileSystem.exists(tailwindConfigPath))
        })
    }
    
    func test_run() async throws {
        try await withTemporaryDirectory(removeTreeOnDeinit: true, { tmpDir in
            // Given
            let subject = SwiftyTailwind(directory: tmpDir)
            
            let inputCSSPath = tmpDir.appending(component: "input.css")
            let inputCSSContent = """
            @tailwind components;
            
            p {
                @apply font-bold;
            }
            """
            let outputCSSPath = tmpDir.appending(component: "output.css")
            
            try localFileSystem.writeFileContents(inputCSSPath, bytes: ByteString(inputCSSContent.utf8))
            
            // When
            try await subject.run(input: inputCSSPath, output: outputCSSPath, directory: tmpDir)
            
            // Then
            let content = String(bytes: try localFileSystem.readFileContents(outputCSSPath).contents, encoding: .utf8)
            XCTAssertTrue(localFileSystem.exists(outputCSSPath))
            XCTAssertTrue(content?.contains("font-weight: 700") != nil)
        })
    }
}

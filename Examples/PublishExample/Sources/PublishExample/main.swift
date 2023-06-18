import Foundation
import Publish
import Plot
import SwiftyTailwind
import TSCBasic

struct DeliciousRecipes: Website {
    enum SectionID: String, WebsiteSectionID {
        case recipes
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var ingredients: [String]
    }

    var url = URL(string: "https://cooking-with-john.com")!
    var name = "Delicious Recipes"
    var description = "Many very delicious recipes."
    var language: Language { .english }
    var imagePath: Path? { "images/logo.png" }
}

let tailwind = SwiftyTailwind()

try DeliciousRecipes().publish(withTheme: .tailwind, plugins: [
    .init(name: "Tailwind", installer: { context in
        let rootDirectory = try! AbsolutePath(validating: try context.folder(at: "/").path)
        try await tailwind.run(input: rootDirectory.appending(components: ["Resources", "input.css"]),
                               output: rootDirectory.appending(components: ["Resources", "output.css"]))
    })
])

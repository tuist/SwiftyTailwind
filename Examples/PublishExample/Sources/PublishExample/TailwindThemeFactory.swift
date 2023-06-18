import Foundation
import Publish
import Plot

extension Theme {
    static var tailwind: Self {
        Theme(
            htmlFactory: TailwindThemeFactory(),
            resourcePaths: ["Resources/output.css"]
        )
    }
}

struct TailwindThemeFactory<Site: Website>: HTMLFactory {
    func makeSectionHTML(for section: Publish.Section<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        return HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body {
            }
        )
    }
    
    func makeItemHTML(for item: Publish.Item<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        return HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body {
            }
        )
    }
    
    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        return HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body {
            }
        )
    }
    
    func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        return nil
    }
    
    func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        return nil
    }
    

    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        return HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body {
            }
        )
    }
}

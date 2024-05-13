# SwiftyTailwind 🍃
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftuist%2FSwiftyTailwind%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/tuist/SwiftyTailwind)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftuist%2FSwiftyTailwind%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/tuist/SwiftyTailwind)
[![Netlify Status](https://api.netlify.com/api/v1/badges/69daef71-b1cf-4d37-96ad-216cb953e668/deploy-status)](https://app.netlify.com/sites/swiftytailwind/deploys)
[![SwiftyTailwind](https://github.com/tuist/SwiftyTailwind/actions/workflows/SwiftyTailwind.yml/badge.svg)](https://github.com/tuist/SwiftyTailwind/actions/workflows/SwiftyTailwind.yml)

**SwiftyTailwind** is a Swift Package to lazily download and run the [Tailwind](https://tailwindcss.com) CLI from a Swift project (e.g. [Vapor](https://vapor.codes) app or [Publish](https://github.com/JohnSundell/Publish) project). 

## Usage

First, you need to add `SwiftyTailwind` as a dependency in your project's `Package.swift`:

```swift
.package(url: "https://github.com/tuist/SwiftyTailwind.git", .upToNextMinor(from: "0.5.0"))
```

Once added, you'll create an instance of `SwiftyTailwind` specifying the version you'd like to use and where you'd like it to be downloaded.

```swift
let tailwind = SwiftyTailwind(version: .latest, directory: "./cache")
```

If you don't pass any argument, it defaults to the latest version in the system's default temporary directory. If you work in a team, we recommend fixing the version to minimize non-determinism across environments.

### Initializing a `tailwind.config.js`

You can create a `tailwind.config.js` configuration file by running the [`initialize`](https://swiftytailwind.tuist.io/documentation/swiftytailwind/swiftytailwind/initialize(directory:options:)) function on the `SwiftyTailwind` instance:


```swift
try await tailwind.initialize()
```

Check out all the available options in [the documentation](https://swiftytailwind.tuist.io/documentation/swiftytailwind/swiftytailwind/initializeoption).

### Running Tailwind

To run Tailwind against a project, you can use the [`run`](https://swiftytailwind.tuist.io/documentation/swiftytailwind/swiftytailwind/run(input:output:directory:options:)) function:

```swift
try await subject.run(input: inputCSSPath, output: outputCSSPath, options: .content("views/**/*.html"))
```

If you'd like Tailwind to keep watching for file changes, you can pass the `.watch` option:


```swift
try await subject.run(input: inputCSSPath, 
                      output: outputCSSPath, 
                      options: .watch, .content("views/**/*.html"))
```

Check out all the available options in the [documentation](https://swiftytailwind.tuist.io/documentation/swiftytailwind/swiftytailwind/runoption).

### Integrating with Vapor

You can integrate this with Vapor by setting up a `tailwind.swift`:

```swift
import SwiftyTailwind
import TSCBasic
import Vapor

func tailwind(_ app: Application) async throws {
  let resourcesDirectory = try AbsolutePath(validating: app.directory.resourcesDirectory)
  let publicDirectory = try AbsolutePath(validating: app.directory.publicDirectory)

  let tailwind = SwiftyTailwind()
  try await tailwind.run(
    input: .init(validating: "Styles/app.css", relativeTo: resourcesDirectory),
    output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
    options: .content("\(app.directory.viewsDirectory)/**/*.leaf")
  )
}
```

Then in `configure.swift`:

```swift
try await tailwind(app)
app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
```

And in your `index.leaf`:

```html
<link rel="stylesheet" href="/styles/app.generated.css" />
```
### Running Vapor and Tailwind watch in parallel

It can be desirable for Tailwind to watch and rebuild changes without restarting the Vapor server.
It is also best to restrict this behavior for development only.

You can integrate this behavior by setting up a `tailwind.swift`:

```swift
#if DEBUG
import SwiftyTailwind
import TSCBasic
import Vapor

func runTailwind(_ app: Application) async throws {
    let resourcesDirectory = try AbsolutePath(validating: app.directory.resourcesDirectory)
    let publicDirectory = try AbsolutePath(validating: app.directory.publicDirectory)
    let tailwind = SwiftyTailwind()
    
    async let runTailwind: () = tailwind.run(
        input: .init(validating: "Styles/app.css", relativeTo: resourcesDirectory),
        output: .init(validating: "styles/app.generated.css", relativeTo: publicDirectory),
        options: .watch, .content("\(app.directory.viewsDirectory)/**/*.leaf"))
    return try await runTailwind
}
#endif
```

and then in `entrypoint.swift`, replace `try await app.execute()` with:

```swift
#if DEBUG
        if (env.arguments.contains { arg in arg == "migrate" }) {
            try await app.execute()
        } else {
            async let runApp: () = try await app.execute()
            _ = await [try runTailwind(app), try await runApp]
        }
#else
        try await app.execute()
#endif
```

The check for `migrate` in the arguments will ensure that it doesn't run when doing migrations in development.
Additionally, it may be a good idea to setup a script to minify the CSS before deploying to production.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/csjones"><img src="https://avatars.githubusercontent.com/u/637026?v=4?s=100" width="100px;" alt="Chris"/><br /><sub><b>Chris</b></sub></a><br /><a href="#content-csjones" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/wSedlacek"><img src="https://avatars.githubusercontent.com/u/8206108?v=4?s=100" width="100px;" alt="William Sedlacek"/><br /><sub><b>William Sedlacek</b></sub></a><br /><a href="https://github.com/tuist/SwiftyTailwind/commits?author=wSedlacek" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.bradyklein.com"><img src="https://avatars.githubusercontent.com/u/31358894?v=4?s=100" width="100px;" alt="Brady Klein"/><br /><sub><b>Brady Klein</b></sub></a><br /><a href="https://github.com/tuist/SwiftyTailwind/commits?author=bklein18" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

# SwiftyTailwind 🍃
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftuist%2FSwiftyTailwind%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/tuist/SwiftyTailwind)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftuist%2FSwiftyTailwind%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/tuist/SwiftyTailwind)
[![Netlify Status](https://api.netlify.com/api/v1/badges/69daef71-b1cf-4d37-96ad-216cb953e668/deploy-status)](https://app.netlify.com/sites/swiftytailwind/deploys)
[![SwiftyTailwind](https://github.com/tuist/SwiftyTailwind/actions/workflows/SwiftyTailwind.yml/badge.svg)](https://github.com/tuist/SwiftyTailwind/actions/workflows/SwiftyTailwind.yml)

**SwiftyTailwind** is a Swift Package to lazily download and run the [Tailwind](https://tailwindcss.com) CLI from a Swift project (e.g. [Vapor](https://vapor.codes) app or [Publish](https://github.com/JohnSundell/Publish) project). 

## Usage

First, you need to add `SwiftyTailwind` as a dependency in your project's `Package.swift`:

```swift
.package(url: "https://github.com/tuist/SwiftyTailwind.git", .upToNextMinor(from: "0.1.0"))
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

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/csjones"><img src="https://avatars.githubusercontent.com/u/637026?v=4?s=100" width="100px;" alt="Chris"/><br /><sub><b>Chris</b></sub></a><br /><a href="#content-csjones" title="Content">🖋</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
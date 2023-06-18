// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PublishExample",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "PublishExample", targets: ["PublishExample"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", .upToNextMinor(from: "0.9.0")),
        .package(path: "../../")
    ],
    targets: [
        .target(
            name: "PublishExample",
            dependencies: [
                .product(name: "Publish", package: "publish"),
                .product(name: "SwiftyTailwind", package: "SwiftyTailwind")
            ]
        )
    ]
)

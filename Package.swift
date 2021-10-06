// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StaticSite",
    dependencies: [
        .package(name: "HTML", url: "https://github.com/robb/Swim.git", .branch("main")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "StaticSite",
            dependencies: [
                .product(name: "Swim", package: "HTML"),
                .product(name: "HTML", package: "HTML"),
            ]),
        .testTarget(
            name: "StaticSiteTests",
            dependencies: ["StaticSite"]),
    ]
)

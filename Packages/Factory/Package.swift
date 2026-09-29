// swift-tools-version: 5.9
// Tools version 5.9 builds this package in the Swift 5 language mode with minimal
// concurrency checking, so the vendored Factory source is exempt from strict checks.

import PackageDescription

let package = Package(
    name: "Factory",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Factory", targets: ["Factory"])
    ],
    targets: [
        .target(name: "Factory")
    ]
)

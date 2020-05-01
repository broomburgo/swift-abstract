// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftAbstract",
    products: [
        .library(name: "swift-abstract", targets: ["SwiftAbstract"]),
    ],
    targets: [
        .target(name: "SwiftAbstract", dependencies: []),
        .testTarget(name: "SwiftAbstractTests", dependencies: ["SwiftAbstract"]),
    ]
)

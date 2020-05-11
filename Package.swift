// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-abstract",
  products: [
    .library(name: "SwiftAbstract", type: .dynamic, targets: ["SwiftAbstract"]),
  ],
  dependencies: [
    .package(url: "https://github.com/typelift/SwiftCheck.git", .exact("0.12.0"))
  ],
  targets: [
    .target(name: "SwiftAbstract", dependencies: []),
    .testTarget(name: "SwiftAbstractTests", dependencies: ["SwiftAbstract", "SwiftCheck"]),
  ]
)

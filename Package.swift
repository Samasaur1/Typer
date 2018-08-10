// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "Typer",
    products: [
        .library(name: "Typer", targets: ["Typer"]),
    ],
    targets: [
        .target(name: "Typer", dependencies: []),
        .testTarget(name: "TyperTests", dependencies: ["Typer"]),
    ]
)

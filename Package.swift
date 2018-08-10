// swift-tools-version:4.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "Typer",
    products: [
        .library(name: "Typer", targets: ["Typer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
    ],
    targets: [
        .target(name: "Typer", dependencies: ["ShellOut"]),
        .testTarget(name: "TyperTests", dependencies: ["Typer"]),
    ]
)

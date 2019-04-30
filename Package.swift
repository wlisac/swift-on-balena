// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftOnBalena",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.0.0"),
        .package(url: "https://github.com/JohnSundell/Files.git", from: "3.1.0")
    ],
    targets: [
        .target(
            name: "Run",
            dependencies: [
                "Commander",
                "SwiftOnBalena"
            ]),
        .target(
            name: "SwiftOnBalena",
            dependencies: [
                "SwiftShell",
                "Files"
            ])
    ]
)

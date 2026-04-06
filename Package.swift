// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiscordGameKit",
    platforms: [.macOS(.v11), .iOS(.v15)],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DiscordGameKit",
            dependencies: ["discord_partner_sdk"],
            swiftSettings: [.unsafeFlags(["-enable-library-evolution", "-emit-module-interface"])]
        ),
        .executableTarget(
            name: "DiscordGameRunner",
            dependencies: ["DiscordGameKit"]
        ),
        .binaryTarget(name: "discord_partner_sdk", path: "discord_partner_sdk.xcframework")
    ],
    swiftLanguageModes: [.v6]
)

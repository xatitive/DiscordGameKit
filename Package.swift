// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let sourcesDirectory = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .appending(path: "Sources")

let discordTBD = sourcesDirectory.appending(path: "CDiscord/libdiscord_partner_sdk.tbd")
let discordLinkerSetting = LinkerSetting.unsafeFlags([discordTBD.path])


let package = Package(
    name: "DiscordGameKit",
    platforms: [.macOS(.v11), .iOS(.v15)],
    products: [
        .library(
            name: "DiscordGameKit",
            targets: ["DiscordGameKit"]
        )
    ],
    traits: [
        .trait(name: "asyncCallbacks"),
        .default(enabledTraits: ["asyncCallbacks"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DiscordGameKit",
            dependencies: ["CDiscord"],
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution", "-emit-module-interface"]),
                .define("asyncCallbacks"),
            ],
            linkerSettings: [discordLinkerSetting]
        ),
        .executableTarget(
            name: "DiscordGameRunner",
            dependencies: ["DiscordGameKit"],
            swiftSettings: [
                .define("asyncCallbacks")
            ]
        ),
        .systemLibrary(name: "CDiscord", path: nil, pkgConfig: nil, providers: nil),
        //.binaryTarget(name: "discord_partner_sdk", path: "discord_partner_sdk.xcframework")
    ],
    swiftLanguageModes: [.v6]
)

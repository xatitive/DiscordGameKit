// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let extraSettings: [SwiftSetting] = [
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("LifetimeDependence"),
    .enableUpcomingFeature("LifetimeDependence"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("InternalImportsByDefault"),
    //    .treatAllWarnings(as: .error),
    //.strictMemorySafety(),
    .enableExperimentalFeature("SafeInteropWrappers"),
    .unsafeFlags(["-Xcc", "-fexperimental-bounds-safety-attributes"]),
]

let sourcesDirectory = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .appending(path: "Sources")

let discordTBD = sourcesDirectory.appending(path: "discord_partner_sdk/libdiscord_partner_sdk.tbd")
let discordLinkerSetting = LinkerSetting.unsafeFlags([discordTBD.path])


let package = Package(
    name: "DiscordGameKit",
    platforms: [.macOS(.v26), .iOS(.v26)],
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
            name: "discord_partner_sdk",
            swiftSettings: extraSettings,
            linkerSettings: [discordLinkerSetting]
        ),
        .target(
            name: "DiscordGameKit",
            dependencies: ["discord_partner_sdk"],
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution", "-emit-module-interface"]),
                .define("asyncCallbacks"),
            ] + extraSettings,
        ),
        .executableTarget(
            name: "DiscordGameRunner",
            dependencies: ["DiscordGameKit"],
            swiftSettings: [
                .define("asyncCallbacks")
            ] + extraSettings
        ),
        //.systemLibrary(name: "CDiscord", path: "Sources/CDiscord", pkgConfig: nil, providers: nil),
        //.binaryTarget(name: "discord_partner_sdk", path: "discord_partner_sdk.xcframework")
    ],
    swiftLanguageModes: [.v6]
)

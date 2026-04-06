// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import DiscordGameKit

let appId = try! applicationIdFromEnv(at: "/Users/chris/Documents/DiscordGameKit-xatitive/Sources/DiscordGameRunner/.env")

@main
struct DiscordGameRunner {
    static func main() {
        let client = DiscordClient()
        
        client.onLog { message, severity in
            print("[\(severity)] \(message)")
        }
        
    }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import DiscordGameKit

@main
struct DiscordGameRunner {
    static func main() {
        let client = DiscordClient()
        
        client.onLog { message, severity in
            print("[\(severity)] \(message)")
        }
        
    }
}

//
//  EnvReader.swift
//  DiscordGameKit-xatitive
//
//  Created by Christian Norton on 4/5/26.
//

import Foundation

extension String: LocalizedError {}

func applicationIdFromEnv(at path: String) throws -> UInt64 {
    let fileUrl = URL(fileURLWithPath: path)
    let contents = try String(contentsOf: fileUrl)
    
    for line in contents.components(separatedBy: .newlines) {
        guard let range = line.range(of: "=") else { continue }
        let key = String(line[..<range.lowerBound]).trimmingCharacters(
            in: .whitespaces
        )
        let value = String(line[range.upperBound...]).trimmingCharacters(
            in: .whitespaces
        )
        guard key == "DISCORD_APPLICATION_ID", let intValue = UInt64(value) else { throw "Couldn't convert to UInt64" }
        return intValue
    }
    
    throw "No .env file found to get the key from!"
}

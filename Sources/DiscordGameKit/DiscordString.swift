//
//  DiscordString.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 3/20/26.
//

import Foundation

@_implementationOnly import discord_partner_sdk

extension String {
    /// Copies a Discord-owned string into Swift, then frees the Discord buffer.
    /// Use this for any string Discord allocates and returns to you.
    init(discordOwned ds: Discord_String) {
        self = String(decoding: ds.buffer, as: UTF8.self)
        Discord_Free(ds.ptr)
    }

    /// Wraps a Discord_String Discord does NOT own (e.g. a string you own that you're just reading back).
    /// No free is called.
    init(discordBorrowed ds: Discord_String) {
        self = String(bytes: ds.buffer, encoding: .utf8) ?? ""
    }
}


extension String {
    func withDiscordString<T>(_ body: (Discord_String) throws -> T) rethrows
        -> T
    {
        try withDiscordStringPointer { try body($0.pointee) }
    }

    func withDiscordStringPointer<T>(
        _ body: (UnsafeMutablePointer<Discord_String>) throws -> T
    ) rethrows -> T {
        if let result = try utf8.withContiguousStorageIfAvailable({ buffer in
            var ds = Discord_String(
                ptr: UnsafeMutablePointer(mutating: buffer.baseAddress),
                size: buffer.count
            )
            return try withUnsafeMutablePointer(to: &ds) { try body($0) }
        }) {
            return result
        }

        var copy = Array(utf8)
        return try copy.withUnsafeMutableBufferPointer { buffer in
            var ds = Discord_String(ptr: buffer.baseAddress, size: buffer.count)
            return try withUnsafeMutablePointer(to: &ds) { try body($0) }
        }
    }
}


extension Dictionary where Key == String, Value == String {
    func withDiscordProperties<T>(
        _ body: (Discord_Properties) throws -> T
    ) rethrows -> T {
        var properties = Discord_Properties()
        properties.size = count

        if properties.size > 0 {
            properties.keys = UnsafeMutablePointer<Discord_String>(
                OpaquePointer(Discord_Alloc(properties.size * MemoryLayout<Discord_String>.stride))
            )
            properties.values = UnsafeMutablePointer<Discord_String>(
                OpaquePointer(Discord_Alloc(properties.size * MemoryLayout<Discord_String>.stride))
            )

            for (index, pair) in enumerated() {
                properties.keys[index] = pair.key.discordCopiedString
                properties.values[index] = pair.value.discordCopiedString
            }
        }

        defer { Discord_FreeProperties(properties) }
        return try body(properties)
    }
}

extension Discord_Properties {
    func toDictionary() -> [String: String] {
        var result: [String: String] = [:]
        result.reserveCapacity(size)

        guard size > 0, let keys, let values else {
            return result
        }

        let keyBuffer = UnsafeBufferPointer(start: keys, count: size)
        let valueBuffer = UnsafeBufferPointer(start: values, count: size)

        for (key, value) in zip(keyBuffer, valueBuffer) {
            result[String(discordBorrowed: key)] = String(discordBorrowed: value)
        }

        return result
    }

    func toOwnedDictionary() -> [String: String] {
        defer { Discord_FreeProperties(self) }
        return toDictionary()
    }
}

extension String {
    var discordCopiedString: Discord_String {
        let bytes = Array(utf8)
        let raw = Discord_Alloc(bytes.count)
        let pointer = raw.map { UnsafeMutablePointer<UInt8>(OpaquePointer($0)) }

        if let pointer {
            bytes.withUnsafeBufferPointer { source in
                pointer.initialize(from: source.baseAddress!, count: bytes.count)
            }
        }

        return Discord_String(ptr: pointer, size: bytes.count)
    }
}

extension MutableSpan where Element == UInt8 {
    func toString() -> String {
        let count = self.span.count
        if count == 0 {
            return ""
        }

        var bytes: [UInt8] = []
        bytes.reserveCapacity(count)

        var i = 0
        while i < count {
            let byte = self.span[i]
            if byte == 0 {
                break
            }
            bytes.append(byte)
            i += 1
        }

        return String(decoding: bytes, as: UTF8.self)
    }
}

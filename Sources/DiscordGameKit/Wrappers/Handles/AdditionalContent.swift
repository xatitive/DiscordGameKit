//
//  AdditionalContent.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Contains information about non-text content in a message that likely cannot be rendered in game such as images, videos, embeds, polls, and more.
public struct AdditionalContent: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_AdditionalContent>
    init(storage: DiscordStorage<Discord_AdditionalContent>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// Represents the type of additional content in the message.
    public var type: AdditionalContentType {
        get { storage.withLock { $0.type().swiftValue } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setType(newValue.discordValue)
            }
        }
    }

    /// When the additional content is a poll or thread, this field will contain the name of the poll or thread.
    public var title: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                guard raw.title(&ds) else { return nil }
                return ds.toString()
            }
        }
        _modify {
            ensureUnique()
            var value = self.title
            yield &value
            guard let value else {
                usingLock { $0.setTitle(nil) }
                return
            }
            value.withDiscordStringPointer { ptr in
                storage.withLock { raw in
                    raw.setTitle(ptr)
                }
            }
        }
    }

    /// Represents the number of pieces of additional content so you could for example render "2 additional images".
    public var count: UInt8 {
        get { usingLock { $0.count() } }
        set {
            ensureUnique()
            usingLock { $0.setCount(newValue) }
        }
    }

    public var description: String {
        "AdditionalContent(type: \(type), title: \(title, default: "N/A"), count: \(count))"
    }
}

extension AdditionalContent: Equatable {
    public static func == (lhs: AdditionalContent, rhs: AdditionalContent) -> Bool {
        compare(lhs.storage, to: rhs.storage) { (lhsPtr: UnsafeMutablePointer<Discord_AdditionalContent>?, rhsPtr: UnsafePointer<Discord_AdditionalContent>?) -> Bool in
            guard let lhsPtr else { return false }
            return lhsPtr.pointee.equals(rhsPtr)
        }
    }
}

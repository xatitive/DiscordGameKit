//
//  AdditionalContent.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Contains information about non-text content in a message that likely cannot be rendered in game such as images, videos, embeds, polls, and more.
public struct AdditionalContent: DiscordObject {
    var storage: DiscordStorage<Discord_AdditionalContent>
    init(storage: DiscordStorage<Discord_AdditionalContent>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// Represents the type of additional content in the message.
    public var type: AdditionalContentType {
        get {
            storage.withLock { raw in
                AdditionalContentType(
                    rawValue: Int32(Discord_AdditionalContent_Type(&raw).rawValue)
                )!
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_AdditionalContent_SetType(&raw, newValue.discordValue)
            }
        }
    }

    /// When the additional content is a poll or thread, this field will contain the name of the poll or thread.
    public var title: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                guard Discord_AdditionalContent_Title(&raw, &ds) else { return nil }
                return String(discordOwned: ds)
            }
        }
        _modify {
            ensureUnique()
            var value = self.title
            yield &value
            guard let value else {
                usingLock(Discord_AdditionalContent_SetTitle, nil)
                return
            }
            value.withDiscordStringPointer { ptr in
                storage.withLock { raw in
                    Discord_AdditionalContent_SetTitle(&raw, ptr)
                }
            }
        }
    }

    /// Represents the number of pieces of additional content so you could for example render "2 additional images".
    public var count: UInt8 {
        get { usingLock(Discord_AdditionalContent_Count) }
        set {
            ensureUnique()
            usingLock(Discord_AdditionalContent_SetCount, newValue)
        }
    }
}

extension AdditionalContent: Equatable {
    public static func == (lhs: AdditionalContent, rhs: AdditionalContent) -> Bool {
        compare(lhs.storage, to: rhs.storage, Discord_AdditionalContent_Equals)
    }
}

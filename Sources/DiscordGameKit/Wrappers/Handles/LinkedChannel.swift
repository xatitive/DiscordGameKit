//
//  LinkedChannel.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that stores information about the channel that a lobby is linked to.
public struct LinkedChannel: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_LinkedChannel>
    init(storage: DiscordStorage<Discord_LinkedChannel>) {
        self.storage = storage
    }

    /// ID of the linked channel.
    public var id: UInt64 {
        get { usingLock { $0.id() } }
        set {
            ensureUnique()
            usingLock { $0.setId(newValue) }
        }
    }

    /// Name of the channel.
    public var name: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                raw.name(&ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock { $0.setName(str) }
            }
        }
    }

    /// ID of the guild (aka server) that owns the linked channel.
    public var guildId: UInt64 {
        get { usingLock { $0.guildId() } }
        set {
            ensureUnique()
            usingLock { $0.setGuildId(newValue) }
        }
    }

    public var description: String {
        "LinkedChannel(id: \(id), name: \(name), guildId: \(guildId))"
    }
}

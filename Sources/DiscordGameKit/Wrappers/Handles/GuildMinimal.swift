//
//  GuildMinimal.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Represents a guild (also knowns as a Discord server), that the current user is a member
/// of, that contains channels that can be linked to a lobby.
public struct GuildMinimal: DiscordObject, Identifiable, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_GuildMinimal>
    init(storage: DiscordStorage<Discord_GuildMinimal>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// ID of the guild.
    public var id: UInt64 {
        get { usingLock { $0.id() } }
        set {
            ensureUnique()
            usingLock { $0.setId(newValue) }
        }
    }

    /// Name of the guild.
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

    public var description: String {
        "GuildMinimal(id: \(id), name: \(name))"
    }
}

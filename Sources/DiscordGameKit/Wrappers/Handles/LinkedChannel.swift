//
//  LinkedChannel.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that stores information about the channel that a lobby is linked to.
public struct LinkedChannel: DiscordObject, Sendable {
    var storage: DiscordStorage<Discord_LinkedChannel>
    init(storage: DiscordStorage<Discord_LinkedChannel>) {
        self.storage = storage
    }

    /// ID of the linked channel.
    public var id: UInt64 {
        get { usingLock(Discord_LinkedChannel_Id) }
        set {
            ensureUnique()
            usingLock(Discord_LinkedChannel_SetId, newValue)
        }
    }

    /// Name of the channel.
    public var name: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_LinkedChannel_Name(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock(Discord_LinkedChannel_SetName, str)
            }
        }
    }

    /// ID of the guild (aka server) that owns the linked channel.
    public var guildId: UInt64 {
        get { usingLock(Discord_LinkedChannel_GuildId) }
        set {
            ensureUnique()
            usingLock(Discord_LinkedChannel_SetGuildId, newValue)
        }
    }
}

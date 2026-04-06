//
//  CallInfoHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// Convenience class that represents the state of a single Discord call in a lobby.
public struct CallInfoHandle: DiscordObject {
    var storage: DiscordStorage<Discord_CallInfoHandle>
    init(storage: DiscordStorage<Discord_CallInfoHandle>) {
        self.storage = storage
    }

    /// Lobby ID of call.
    public var channelId: UInt64 {
        usingLock(Discord_CallInfoHandle_ChannelId)
    }

    /// Lobby ID of call.
    public var guildId: UInt64 {
        usingLock(Discord_CallInfoHandle_GuildId)
    }

    /// Returns a list of the user IDs of the participants in the call.
    public var participants: [UInt64] {
        storage.withLock { raw in
            var span = Discord_UInt64Span()
            Discord_CallInfoHandle_GetParticipants(&raw, &span)
            return span.converting()
        }
    }

    /// Accesses the voice state for a single user so you can know if they have muted or deafened themselves.
    public func getVoiceStateHandle(userId: UInt64) -> VoiceStateHandle? {
        storage.withLock { raw -> VoiceStateHandle? in
            var handle = Discord_VoiceStateHandle()
            guard Discord_CallInfoHandle_GetVoiceStateHandle(&raw, userId, &handle) else {
                return nil
            }
            return VoiceStateHandle(takingOwnership: handle)
        }
    }
}

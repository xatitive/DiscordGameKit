//
//  LinkedLobby.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that stores information about the lobby linked to a channel.
public struct LinkedLobby: DiscordObject {
    var storage: DiscordStorage<Discord_LinkedLobby>
    init(storage: DiscordStorage<Discord_LinkedLobby>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// The ID of the application that owns the lobby.
    public var applicationId: UInt64 {
        get { usingLock(Discord_LinkedLobby_ApplicationId) }
        set {
            ensureUnique()
            usingLock(Discord_LinkedLobby_SetApplicationId, newValue)
        }
    }

    /// ID of the lobby.
    public var lobbyId: UInt64 {
        get { usingLock(Discord_LinkedLobby_LobbyId) }
        set {
            ensureUnique()
            usingLock(Discord_LinkedLobby_SetLobbyId, newValue)
        }
    }
}

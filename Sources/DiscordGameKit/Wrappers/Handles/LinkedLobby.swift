//
//  LinkedLobby.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that stores information about the lobby linked to a channel.
public struct LinkedLobby: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_LinkedLobby>
    init(storage: DiscordStorage<Discord_LinkedLobby>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// The ID of the application that owns the lobby.
    public var applicationId: UInt64 {
        get { usingLock { $0.applicationId() } }
        set {
            ensureUnique()
            usingLock { $0.setApplicationId(newValue) }
        }
    }

    /// ID of the lobby.
    public var lobbyId: UInt64 {
        get { usingLock { $0.lobbyId() } }
        set {
            ensureUnique()
            usingLock { $0.setLobbyId(newValue) }
        }
    }

    public var description: String {
        "LinkedLobby(applicationId: \(applicationId), lobbyId: \(lobbyId))"
    }
}

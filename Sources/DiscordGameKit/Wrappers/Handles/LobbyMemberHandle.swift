//
//  LobbyMemberHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// A LobbyMemberHandle represents the state of a single user in a Lobby.
///
/// The SDK separates lobby membership into two concepts:
/// 1. Has the user been added to the lobby by the game developer?
/// If the LobbyMemberHandle exists for a user/lobby pair, then the user has been added to the
/// lobby.
/// 2. Does the user have an active game session that is connected to the lobby and will receive any
/// lobby messages? It is possible for a game developer to add a user to a lobby while they are
/// offline. Also users may temporarily disconnect and rejoin later. So the ``isConnected`` field
/// tells you whether the user is actively connected to the lobby.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct LobbyMemberHandle: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_LobbyMemberHandle>
    init(storage: DiscordStorage<Discord_LobbyMemberHandle>) {
        self.storage = storage
    }

    /// Returns true if the user is allowed to link a channel to this lobby.
    ///
    /// Under the hood this checks if the `LobbyMemberFlags.canLinkLobby` flag is set.
    /// This flag can only be set via the server API, add_lobby_member
    /// The use case for this is for games that want to restrict a lobby so that only the
    /// clan/guild/group leader is allowed to manage the linked channel for the lobby.
    public var canLinkLobby: Bool {
        usingLock(Discord_LobbyMemberHandle_CanLinkLobby)
    }

    /// Returns true if the user is currently connected to the lobby.
    public var isConnected: Bool {
        usingLock(Discord_LobbyMemberHandle_Connected)
    }

    // ID of the lobby member.
    public var id: UInt64 {
        usingLock(Discord_LobbyMemberHandle_Id)
    }

    /// Metadata is a set of string key/value pairs that the game developer can use.
    ///
    /// A common use case may be to store the game's internal user ID for this user so that every
    /// member of a lobby knows the discord user ID and the game's internal user ID mapping for each user.
    public var metadata: [String: String] {
        storage.withLock { raw in
            var properties = Discord_Properties()
            Discord_LobbyMemberHandle_Metadata(&raw, &properties)
            return properties.toOwnedDictionary()
        }
    }

    /// The ``UserHandle`` of the lobby member.
    public var user: UserHandle? {
        storage.withLock { raw -> UserHandle? in
            var handle = Discord_UserHandle()
            guard Discord_LobbyMemberHandle_User(&raw, &handle) else { return nil }
            return UserHandle(takingOwnership: handle)
        }
    }

    public var description: String {
        "LobbyMemberHandle(id: \(id), canLinkLobby: \(canLinkLobby), isConnected: \(isConnected), userId: \(user?.id, default: "N/A"), metadata: \(metadata))"
    }
}

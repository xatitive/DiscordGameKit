//
//  LobbyHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// A LobbyHandle represents a single lobby in the SDK. A lobby can be thought of as
/// just an arbitrary, developer-controlled group of users that can communicate with each other.
///
/// ## Managing Lobbies
/// Lobbies can be managed through a set of @ref server_apis that are documented elsewhere, which
/// allow you to create lobbies, add and remove users from lobbies, and delete them.
///
/// There is also an API to create lobbies without any server side component using the
/// ``DiscordClient/createOrJoinLobby(secret:_:)`` function, which accepts a game-generated secret and will join the user
/// to the lobby associated with that secret, creating it if necessary.
///
/// NOTE: When using this API the secret will auto-expire in 30 days, at which point the existing
/// lobby can no longer be joined, but will still exist. We recommend using this for short term
/// lobbies and not permanent lobbies. Use the Server API for more permanent lobbies.
///
/// Members of a lobby are not automatically removed when they close the game or temporarily
/// disconnect. When the SDK connects, it will attempt to re-connect to any lobbies it is currently
/// a member of.
///
/// # Lobby Auto-Deletion
/// Lobbies are generally ephemeral and will be auto-deleted if they have been idle (meaning no
/// users are actively connected to them) for some amount of time. The default is to auto delete
/// after 5 minutes, but this can be customized when creating the lobby. As long as one user is
/// connected to the lobby though it will not be auto-deleted (meaning they have the SDK running and
/// status is set to Ready). Additionally, lobbies that are linked to a channel on Discord will not
/// be auto deleted.
///
/// You can also use the server_apis to customize this timeout, it can be raised to as high as
/// 7 days, meaning the lobby only gets deleted if no one connects to it for an entire week. This
/// should give a good amount of permanence to lobbies when needed, but there may be rare cases
/// where a lobby does need to be "rebuilt" if everyone is offline for an extended period.
///
/// # Membership Limits
/// Lobbies may have a maximum of 1,000 members, and each user may be in a maximum of 200 lobbies
/// per game.
///
/// ## Audio
/// Lobbies support voice calls. Although a lobby is allowed to have 1,000 members, you should not
/// try to start voice calls in lobbies that large. We strongly recommend sticking to around 25
/// members or fewer for voice calls.
///
/// See ``DiscordClient/startCall(in:)`` for more information on how to start a voice call in a lobby.
///
/// ## Channel Linking
/// Lobbies can be linked to a channel on Discord, which allows messages sent in one place to show
/// up in the other. Any lobby can be linked to a channel, but only lobby members with the
/// `LobbyMemberFlags.canLinkLobby` flag are allowed to a link a lobby. This flag must be set using
/// the server APIs, which allows you to ensure that only clan/guild/group leaders can link lobbies
/// to Discord channels.
///
/// To setup a link you'll need to use methods in the Client class to fetch the servers (aka guilds)
/// and channels a user is a member of and setup the link. The ``DiscordClient/userGuilds(_:)`` and
/// ``DiscordClient/guildChannels(for:_:)`` methods are used to fetch the servers and channels respectively. You
/// can use these to show a UI for the user to pick which server and channel they want to link to.
///
/// Not all channels are linkable. To be linked:
/// - The channel must be a guild text channel
/// - The channel may not be marked as NSFW
/// - The channel must not be currently linked to a different lobby
/// - The user must have the following permissions in the channel in order to link it:
///   - Manage Channels
///   - View Channel
///   - Send Messages
///
/// ### Linking Private Channels
/// Discord is allowing all channels the user has access to in a server to be linked in game, even
/// if that channel is private to other members of the server. This means that a user could choose
/// to link a private "admins chat" channel (assuming they are an admin) in game if they wanted.
///
/// It's not really possible for the game to know which users should have access to that channel or
/// not though. So in this implementation, every member of a lobby will be able to view all messages
/// sent in the linked channel and reply to them. If you are going to allow private channels to be
/// linked in game, you must make sure that users are aware that their private channel will be
/// viewable by everyone in the lobby!
///
/// To help you identify which channels are public or private, we have added a ``GuildChannel/isViewableAndWriteableByAllMembers`` boolean.
/// You can use that to just not allow private channels to be linked, or to know when to show a clear warning, it's up to you!
///
/// ## Misc
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct LobbyHandle: DiscordObject, Identifiable, Sendable {
    var storage: DiscordStorage<Discord_LobbyHandle>
    init(storage: DiscordStorage<Discord_LobbyHandle>) {
        self.storage = storage
    }

    /// ID of the lobby.
    public var id: UInt64 {
        usingLock(Discord_LobbyHandle_Id)
    }

    /// Returns information about the channel linked to this lobby, if any.
    public var linkedChannel: LinkedChannel? {
        storage.withLock { raw -> LinkedChannel? in
            var channel = Discord_LinkedChannel()
            guard Discord_LobbyHandle_LinkedChannel(&raw, &channel) else { return nil }
            return LinkedChannel(takingOwnership: channel)
        }
    }

    /// Returns a list of the user IDs that are members of this lobby.
    public var lobbyMemberIds: [UInt64] {
        storage.withLock { raw in
            var span = Discord_UInt64Span()
            Discord_LobbyHandle_LobbyMemberIds(&raw, &span)
            return span.converting()
        }
    }

    /// Returns a list of the LobbyMemberHandle objects for each member of this lobby.
    public var lobbyMembers: [LobbyMemberHandle] {
        storage.withLock { raw in
            var span = Discord_LobbyMemberHandleSpan()
            Discord_LobbyHandle_LobbyMembers(&raw, &span)
            return span.converting()
        }
    }

    /// Returns any developer supplied metadata for this lobby.
    ///
    /// Metadata is simple string key/value pairs and is a way to associate internal game
    /// information with the lobby so each lobby member can have easy access to.
    public var metadata: [String: String] {
        storage.withLock { raw in
            var properties = Discord_Properties()
            Discord_LobbyHandle_Metadata(&raw, &properties)
            return properties.toOwnedDictionary()
        }
    }

    /// Returns a reference to the CallInfoHandle if there is an active voice call in this lobby.
    ///
    /// This can allow you to display which lobby members are in voice, even if the current user has not yet joined the voice call.
    public func callInfo() -> CallInfoHandle? {
        storage.withLock { raw -> CallInfoHandle? in
            var handle = Discord_CallInfoHandle()
            guard Discord_LobbyHandle_GetCallInfoHandle(&raw, &handle) else { return nil }
            return CallInfoHandle(takingOwnership: handle)
        }
    }

    /// Returns a reference to the LobbyMemberHandle for the given user ID, if they are a member of this lobby.
    public func getLobbyMemberHandle(for member: UInt64) -> LobbyMemberHandle? {
        storage.withLock { raw -> LobbyMemberHandle? in
            var handle = Discord_LobbyMemberHandle()
            guard Discord_LobbyHandle_GetLobbyMemberHandle(&raw, member, &handle) else {
                return nil
            }
            return LobbyMemberHandle(takingOwnership: handle)
        }
    }
}

//
//  GuildChannel.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Represents a channel in a guild that the current user is a member of and may be able to be linked to a lobby.
public struct GuildChannel: DiscordObject, Identifiable {
    var storage: DiscordStorage<Discord_GuildChannel>
    init(storage: DiscordStorage<Discord_GuildChannel>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// ID of the channel.
    public var id: UInt64 {
        get { usingLock(Discord_GuildChannel_Id) }
        set {
            ensureUnique()
            usingLock(Discord_GuildChannel_SetId, newValue)
        }
    }

    /// Name of the channel.
    public var name: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_GuildChannel_Name(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock(Discord_GuildChannel_SetName, str)
            }
        }
    }

    /// Type of the channel.
    public var type: ChannelType {
        get {
            storage.withLock { raw in
                ChannelType(
                    rawValue: Int32(Discord_GuildChannel_Type(&raw).rawValue)
                )!
            }
        }
        set {
            ensureUnique()
            usingLock(Discord_GuildChannel_SetType, newValue.discordValue)
        }
    }

    /// The position of the channel in the guild's channel list.
    public var position: Int32 {
        get { usingLock(Discord_GuildChannel_Position) }
        set {
            ensureUnique()
            usingLock(Discord_GuildChannel_SetPosition, newValue)
        }
    }

    /// The id of the parent category channel, if any.
    public var parentId: UInt64? {
        get {
            storage.withLock { raw in
                var id = UInt64(0)
                guard Discord_GuildChannel_ParentId(&raw, &id) else { return nil }
                return id
            }
        }
        _modify {
            ensureUnique()
            var value = self.parentId
            yield &value
            guard var value else {
                usingLock(Discord_GuildChannel_SetParentId, nil)
                return
            }
            storage.withLock { raw in
                Discord_GuildChannel_SetParentId(&raw, &value)
            }
        }
    }

    /// Whether the current user is able to link this channel to a lobby.
    ///
    /// For this to be true:
    /// - The channel must be a guild text channel
    /// - The channel may not be marked as NSFW
    /// - The channel must not be currently linked to a different lobby
    /// - The user must have the following permissions in the channel in order to link it:
    ///   - Manage Channels
    ///   - View Channel
    ///   - Send Messages
    public var isLinkable: Bool {
        get { usingLock(Discord_GuildChannel_IsLinkable) }
        set {
            ensureUnique()
            usingLock(Discord_GuildChannel_SetIsLinkable, newValue)
        }
    }

    /// Whether the channel is "fully public" which means every member of the guild is able
    /// to view and send messages in that channel.
    ///
    /// Discord allows lobbies to be linked to private channels
    /// in a server, which enables things like a private admin chat.
    ///
    /// However there is no permission synchronization between the game and Discord, so it is the
    /// responsibility of the game to restrict access to the lobby. Every member of the lobby will
    /// be able to view and send messages in the lobby/channel, regardless of whether that user
    /// would have permission to do so in Discord.
    ///
    /// This may be more complexity than a game wants to take on, so instead you can only allow
    /// linking of channels that are fully public in the server so there is no confusion.
    public var isViewableAndWriteableByAllMembers: Bool {
        get { usingLock(Discord_GuildChannel_IsViewableAndWriteableByAllMembers) }
        set {
            ensureUnique()
            usingLock(Discord_GuildChannel_SetIsViewableAndWriteableByAllMembers, newValue)
        }
    }

    /// Information about the currently linked lobby, if any.
    ///
    /// Currently Discord enforces that a channel can only be linked to a single lobby.
    public var linkedLobby: LinkedLobby? {
        get {
            storage.withLock { raw -> LinkedLobby? in
                var lobby = Discord_LinkedLobby()
                guard Discord_GuildChannel_LinkedLobby(&raw, &lobby) else { return nil }
                return LinkedLobby(takingOwnership: lobby)
            }
        }
        _modify {
            ensureUnique()
            var value = self.linkedLobby
            yield &value
            guard let value else {
                usingLock(Discord_GuildChannel_SetLinkedLobby, nil)
                return
            }
            value.storage.withLock { lobby in
                self.storage.withLock { raw in
                    Discord_GuildChannel_SetLinkedLobby(&raw, &lobby)
                }
            }
        }
    }
}

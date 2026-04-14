//
//  GuildChannel.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk
public import ViewConfigurable

/// Represents a channel in a guild that the current user is a member of and may be able to be linked to a lobby.
@ViewConfigurable
public struct GuildChannel: DiscordObject, Identifiable, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_GuildChannel>
    init(storage: DiscordStorage<Discord_GuildChannel>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    private var isApplyingViewConfig = false
    private var viewConfig = ViewConfiguration() {
        didSet {
            guard !isApplyingViewConfig else { return }
            applyViewConfigChanges()
        }
    }

    private struct ViewConfiguration {
        var id: UInt64?
        var name: String?
        var type: ChannelType?
        var position: Int32?
        var parentId: UInt64?
        var isLinkable: Bool?
        var isViewableAndWriteableByAllMembers: Bool?
        var linkedLobby: LinkedLobby?
    }

    private mutating func withViewConfigApplicationDisabled(
        _ body: (inout ViewConfiguration) -> Void
    ) {
        isApplyingViewConfig = true
        body(&viewConfig)
        isApplyingViewConfig = false
    }

    private mutating func applyViewConfigChanges() {
        if let id = viewConfig.id {
            self.id = id
        }
        if let name = viewConfig.name {
            self.name = name
        }
        if let type = viewConfig.type {
            self.type = type
        }
        if let position = viewConfig.position {
            self.position = position
        }
        if let parentId = viewConfig.parentId {
            self.parentId = parentId
        }
        if let isLinkable = viewConfig.isLinkable {
            self.isLinkable = isLinkable
        }
        if let isViewableAndWriteableByAllMembers = viewConfig.isViewableAndWriteableByAllMembers {
            self.isViewableAndWriteableByAllMembers = isViewableAndWriteableByAllMembers
        }
        if let linkedLobby = viewConfig.linkedLobby {
            self.linkedLobby = linkedLobby
        }

        withViewConfigApplicationDisabled { $0 = .init() }
    }

    /// ID of the channel.
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
                gettingString { span in
                    raw.name(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { buf in
                    raw.setName(span: buf)
                }
            }
        }
    }

    /// Type of the channel.
    public var type: ChannelType {
        get { storage.withLock { $0.type().swiftValue } }
        set {
            ensureUnique()
            usingLock { $0.setType(newValue.discordValue) }
        }
    }

    /// The position of the channel in the guild's channel list.
    public var position: Int32 {
        get { usingLock { $0.position() } }
        set {
            ensureUnique()
            usingLock { $0.setPosition(newValue) }
        }
    }

    /// The id of the parent category channel, if any.
    public var parentId: UInt64? {
        get {
            storage.withLock { raw in
                var id = UInt64(0)
                guard raw.parentId(&id) else { return nil }
                return id
            }
        }
        _modify {
            ensureUnique()
            var value = self.parentId
            yield &value
            guard var value else {
                usingLock { $0.setParentId(nil) }
                return
            }
            storage.withLock { raw in
                raw.setParentId(&value)
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
        get { usingLock { $0.isLinkable() } }
        set {
            ensureUnique()
            usingLock { $0.setIsLinkable(newValue) }
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
        get { usingLock { $0.isViewableAndWriteableByAllMembers() } }
        set {
            ensureUnique()
            usingLock { $0.setIsViewableAndWriteableByAllMembers(newValue) }
        }
    }

    /// Information about the currently linked lobby, if any.
    ///
    /// Currently Discord enforces that a channel can only be linked to a single lobby.
    public var linkedLobby: LinkedLobby? {
        get {
            storage.withLock { raw -> LinkedLobby? in
                var lobby = Discord_LinkedLobby()
                guard raw.linkedLobby(&lobby) else { return nil }
                return LinkedLobby(takingOwnership: lobby)
            }
        }
        _modify {
            ensureUnique()
            var value = self.linkedLobby
            yield &value
            guard let value else {
                usingLock { $0.setLinkedLobby(nil) }
                return
            }
            value.storage.withLock { lobby in
                self.storage.withLock { raw in
                    raw.setLinkedLobby(&lobby)
                }
            }
        }
    }

    public var description: String {
        "GuildChannel(id: \(id), name: \(name), type: \(type), position: \(position), parentId: \(parentId, default: "N/A"), isLinkable: \(isLinkable), isViewableAndWriteableByAllMembers: \(isViewableAndWriteableByAllMembers), linkedLobby: \(linkedLobby, default: "N/A"))"
    }
}

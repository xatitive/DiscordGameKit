//
//  MessageHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk
import Foundation

/// A ``MessageHandle`` represents a single message received by the SDK.
///
/// # Chat types
/// The SDK supports two types of chat:
/// 1. 1 on 1 chat between two users
/// 2. Chat within a lobby
///
/// You can determine the context a message was sent in with the ``MessageHandle/channel`` and
/// ``ChannelType`` methods. The SDK should only be receiving messages in the following channel
/// types:
/// - DM
/// - Ephemeral DM
/// - Lobby
///
/// # Syncing with Discord
/// In some situations messages sent from the SDK will also show up in Discord.
/// In general this will happen for:
/// - 1 on 1 chat when at least one of the users is a full Discord user
/// - Lobby chat when the lobby is linked to a Discord channel
///
/// Additionally the message must have been sent by a user who is not banned on the Discord side.
///
/// # Legal disclosures
/// As a convenience for game developers, the first time a user sends a message in game, and that
/// message will show up on the Discord client, the SDK will inject a "fake" message into the chat,
/// that contains a basic English explanation of what is happening to the user. You can identify
/// these messages with the ``MessageHandle/disclosureType`` method. We encourage you to customize the
/// rendering of these messages, possibly changing the wording, translating them, and making them
/// look more "official". You can choose to avoid rendering these as well.
///
/// # History
/// The SDK keeps the 25 most recent messages in each channel in memory, but it does not have access
/// to any historical messages sent before the SDK was connected. A ``MessageHandle`` will keep working
/// though even after the SDK has discarded the message for being too old, you just won't be able to
/// create a new MessageHandle objects for that message.
///
/// # Unrenderable Content
/// Messages sent on Discord can contain content that may not be renderable in game, such as images,
/// videos, embeds, polls, and more. The game isn't expected to render these, but instead show a
/// small notice so the user is aware there is more content and a way to view that content on
/// Discord. The MessageHandle::AdditionalContent method will contain data about the non-text
/// content in this message.
///
/// There is also more information about the struct of messages on Discord here:
/// https://discord.com/developers/docs/resources/message
///
/// - note: While the SDK allows you to send messages on behalf of a user, you must only do so in
/// response to a user action. You should never automatically send messages.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct MessageHandle: DiscordObject, Identifiable {
    var storage: DiscordStorage<Discord_MessageHandle>
    init(storage: DiscordStorage<Discord_MessageHandle>) {
        self.storage = storage
    }

    /// If the message contains non-text content, such as images, videos, embeds, polls, etc, this method will return information about that content.
    public var additionalContent: AdditionalContent? {
        storage.withLock { raw -> AdditionalContent? in
            var content = Discord_AdditionalContent()
            guard Discord_MessageHandle_AdditionalContent(&raw, &content) else {
                return nil
            }
            return AdditionalContent(takingOwnership: content)
        }
    }

    /// Returns the application ID associated with this message, if any. You can use this to identify if the mesage was sent from another child application in your catalog.
    ///
    /// - note: Parent / child applications are in limited access and the ``sentFromGame`` field should be relied on for the common case.
    public var applicationId: UInt64? {
        storage.withLock { raw in
            var id: UInt64 = 0
            guard Discord_MessageHandle_ApplicationId(&raw, &id) else {
                return nil
            }
            return id
        }
    }

    /// Returns the UserHandle for the author of this message.
    public var author: UserHandle? {
        storage.withLock { raw in
            var user = Discord_UserHandle()
            guard Discord_MessageHandle_Author(&raw, &user) else {
                return nil
            }
            return UserHandle(takingOwnership: user)
        }
    }

    /// Returns the user ID of the user who sent this message.
    public var authorId: UInt64 {
        usingLock(Discord_MessageHandle_AuthorId)
    }

    /// Returns the ChannelHandle for the channel this message was sent in.
    public var channel: ChannelHandle? {
        storage.withLock { raw -> ChannelHandle? in
            var channel = Discord_ChannelHandle()
            guard Discord_MessageHandle_Channel(&raw, &channel) else {
                return nil
            }
            return ChannelHandle(takingOwnership: channel)
        }
    }

    /// Returns the channel ID this message was sent in.
    public var channelId: UInt64 {
        usingLock(Discord_MessageHandle_ChannelId)
    }

    /// Returns the content of this message, if any.
    ///
    /// A message can be blank if it was sent from Discord but only contains content such as image
    /// attachments. Certain types of markup, such as markup for emojis and mentions, will be auto
    /// replaced with a more human readable form, such as `@username` or `:emoji_name:`.
    public var content: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_MessageHandle_Content(&raw, &ds)
            return String(discordOwned: ds)
        }
    }

    /// f this is an auto-generated message that is explaining some integration behavior to users, this method will return the type of disclosure so you can customize it.
    public var disclosureType: DisclosureType? {
        storage.withLock { raw in
            var type = Discord_DisclosureTypes_forceint
            return Discord_MessageHandle_DisclosureType(&raw, &type) ? type.swiftValue : nil
        }
    }

    /// The timestamp in millis since the epoch when the message was most recently edited.
    ///
    /// Returns nil if the message has not been edited yet.
    public var editedTimestamp: Date? {
        let date = Date(timeIntervalSince1970: TimeInterval(usingLock(Discord_MessageHandle_EditedTimestamp)) / 100)
        return date == Date(timeIntervalSince1970: 0) ? nil : date
    }

    /// Returns the ID of this message.
    public var id: UInt64 {
        usingLock(Discord_MessageHandle_Id)
    }

    /// Returns the LobbyHandle this message was sent in, if it was sent in a lobby.
    public var lobby: LobbyHandle? {
        storage.withLock { raw -> LobbyHandle? in
            var lobby = Discord_LobbyHandle()
            guard Discord_MessageHandle_Lobby(&raw, &lobby) else {
                return nil
            }
            return LobbyHandle(takingOwnership: lobby)
        }
    }

    /// Returns any metadata the developer included with this message.
    ///
    /// Metadata is just a set of simple string key/value pairs.
    /// An example use case might be to include a character name so you can customize how a message
    /// renders in game.
    public var metadata: [String: String] {
        storage.withLock { raw in
            var properties = Discord_Properties()
            Discord_MessageHandle_Metadata(&raw, &properties)
            return properties.toOwnedDictionary()
        }
    }

    /// Returns any moderation metadata the developer set on this message.
    ///
    /// Moderation metadata is just a set of simple string key/value pairs.
    /// An example use case might be to include a flag that indicates the moderation status of the
    /// message. Another example would be to include a re-written message that is more appropriate
    /// for the game's audience.
    public var moderationMetadata: [String: String] {
        storage.withLock { raw in
            var properties = Discord_Properties()
            Discord_MessageHandle_ModerationMetadata(&raw, &properties)
            return properties.toOwnedDictionary()
        }
    }

    /// Returns the content of this message, if any, but without replacing any markup from emojis and mentions.
    ///
    /// A message can be blank if it was sent from Discord but only contains content such as image attachments.
    public var rawContent: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_MessageHandle_RawContent(&raw, &ds)
            return String(discordOwned: ds)
        }
    }

    /// Returns the UserHandle for the other participant in a DM, if this message was sent in a DM.
    public var recipient: UserHandle? {
        storage.withLock { raw -> UserHandle? in
            var user = Discord_UserHandle()
            guard Discord_MessageHandle_Recipient(&raw, &user) else {
                return nil
            }
            return UserHandle(takingOwnership: user)
        }
    }

    /// When this message was sent in a DM or Ephemeral DM, this method will return the ID of the other user in that DM.
    public var recipientId: UInt64 {
        usingLock(Discord_MessageHandle_RecipientId)
    }

    /// Returns true if this message was sent in-game, otherwise false (i.e. from Discord itself).
    ///
    /// If you are using parent / child applications, this will be true if the message was sent from any child application.
    public var sentFromGame: Bool {
        usingLock(Discord_MessageHandle_SentFromGame)
    }

    /// The timestamp in millis since the epoch when the message was sent.
    public var sentTimestamp: Date {
        Date(timeIntervalSince1970: TimeInterval(usingLock(Discord_MessageHandle_SentTimestamp)) / 1000)
    }
}

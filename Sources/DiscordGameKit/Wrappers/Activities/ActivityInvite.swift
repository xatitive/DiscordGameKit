//
//  ActivityInvite.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// When one user invites another to join their game on Discord, it will send a message to
/// that user. The SDK will parse those messages for you automatically, and this struct contains all
/// of the relevant invite information which is needed to later accept that invite.
public struct ActivityInvite: DiscordObject, Sendable {
    var storage: DiscordStorage<Discord_ActivityInvite>
    init(storage: DiscordStorage<Discord_ActivityInvite>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// The user id of the user who sent the invite.
    public var senderId: UInt64 {
        get { storage.withLock { raw in Discord_ActivityInvite_SenderId(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetSenderId(&raw, newValue)
            }
        }
    }

    /// The id of the Discord channel in which the invite was sent.
    public var channelId: UInt64 {
        get { storage.withLock { raw in Discord_ActivityInvite_ChannelId(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetChannelId(&raw, newValue)
            }
        }
    }

    /// The id of the Discord message that contains the invite.
    public var messageId: UInt64 {
        get { storage.withLock { raw in Discord_ActivityInvite_MessageId(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetMessageId(&raw, newValue)
            }
        }
    }

    /// The type of invite that was sent.
    public var type: ActivityActionType {
        get { storage.withLock { Discord_ActivityInvite_Type(&$0).swiftValue } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetType(&raw, newValue.discordValue)
            }
        }
    }

    /// The target application of the invite.
    public var applicationId: UInt64 {
        get { storage.withLock { raw in Discord_ActivityInvite_ApplicationId(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetApplicationId(&raw, newValue)
            }
        }
    }

    /// The application id of the parent - this is only applicable if there is a parent for a publisher's suite of applications.
    public var parentApplicationId: UInt64 {
        get { storage.withLock { raw in Discord_ActivityInvite_ParentApplicationId(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetParentApplicationId(&raw, newValue)
            }
        }
    }

    /// The id of the party the invite was sent for.
    public var partyId: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_ActivityInvite_PartyId(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                storage.withLock { raw in
                    Discord_ActivityInvite_SetPartyId(&raw, str)
                }
            }
        }
    }

    /// The session id of the user who sent the invite.
    public var sessionId: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_ActivityInvite_SessionId(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                storage.withLock { raw in
                    Discord_ActivityInvite_SetSessionId(&raw, str)
                }
            }
        }
    }

    /// Whether or not this invite is currently joinable. An invite becomes invalid if it was sent more than 6 hours ago or if the sender is no longer playing the game the invite is for.
    public var isValid: Bool {
        get { storage.withLock { raw in Discord_ActivityInvite_IsValid(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityInvite_SetIsValid(&raw, newValue)
            }
        }
    }
}

//
//  ActivityInvite.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk
public import ViewConfigurable

/// When one user invites another to join their game on Discord, it will send a message to
/// that user. The SDK will parse those messages for you automatically, and this struct contains all
/// of the relevant invite information which is needed to later accept that invite.
@ViewConfigurable
public struct ActivityInvite: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_ActivityInvite>
    init(storage: DiscordStorage<Discord_ActivityInvite>) {
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
        var senderId: UInt64?
        var channelId: UInt64?
        var messageId: UInt64?
        var type: ActivityActionType?
        var applicationId: UInt64?
        var parentApplicationId: UInt64?
        var partyId: String?
        var sessionId: String?
        var isValid: Bool?
    }

    private mutating func withViewConfigApplicationDisabled(
        _ body: (inout ViewConfiguration) -> Void
    ) {
        isApplyingViewConfig = true
        body(&viewConfig)
        isApplyingViewConfig = false
    }

    private mutating func applyViewConfigChanges() {
        if let senderId = viewConfig.senderId {
            self.senderId = senderId
        }
        if let channelId = viewConfig.channelId {
            self.channelId = channelId
        }
        if let messageId = viewConfig.messageId {
            self.messageId = messageId
        }
        if let type = viewConfig.type {
            self.type = type
        }
        if let applicationId = viewConfig.applicationId {
            self.applicationId = applicationId
        }
        if let parentApplicationId = viewConfig.parentApplicationId {
            self.parentApplicationId = parentApplicationId
        }
        if let partyId = viewConfig.partyId {
            self.partyId = partyId
        }
        if let sessionId = viewConfig.sessionId {
            self.sessionId = sessionId
        }
        if let isValid = viewConfig.isValid {
            self.isValid = isValid
        }

        withViewConfigApplicationDisabled { $0 = .init() }
    }

    /// The user id of the user who sent the invite.
    public var senderId: UInt64 {
        get { storage.withLock { raw in raw.senderId() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setSenderId(newValue)
            }
        }
    }

    /// The id of the Discord channel in which the invite was sent.
    public var channelId: UInt64 {
        get { storage.withLock { raw in raw.channelId() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setChannelId(newValue)
            }
        }
    }

    /// The id of the Discord message that contains the invite.
    public var messageId: UInt64 {
        get { storage.withLock { raw in raw.messageId() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setMessageId(newValue)
            }
        }
    }

    /// The type of invite that was sent.
    public var type: ActivityActionType {
        get { storage.withLock { $0.type().swiftValue } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setType(newValue.discordValue)
            }
        }
    }

    /// The target application of the invite.
    public var applicationId: UInt64 {
        get { storage.withLock { raw in raw.applicationId() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setApplicationId(newValue)
            }
        }
    }

    /// The application id of the parent - this is only applicable if there is a parent for a publisher's suite of applications.
    public var parentApplicationId: UInt64 {
        get { storage.withLock { raw in raw.parentApplicationId() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setParentApplicationId(newValue)
            }
        }
    }

    /// The id of the party the invite was sent for.
    public var partyId: String {
        get {
            storage.withLock { raw in
                gettingString { span in
                    raw.partyId(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setPartyId(span: newValue.utf8Span.span)
            }
        }
    }

    /// The session id of the user who sent the invite.
    public var sessionId: String {
        get {
            storage.withLock { raw in
                gettingString { span in
                    raw.sessionId(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setSessionId(span: newValue.utf8Span.span)
            }
        }
    }

    /// Whether or not this invite is currently joinable. An invite becomes invalid if it was sent more than 6 hours ago or if the sender is no longer playing the game the invite is for.
    public var isValid: Bool {
        get { storage.withLock { raw in raw.isValid() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setIsValid(newValue)
            }
        }
    }
    
    public var description: String {
        "ActivityInvite(senderId: \(senderId), channelId: \(channelId), messageId: \(messageId), type: \(type), applicationId: \(applicationId), parentApplicationId: \(parentApplicationId), partyId: \(partyId), sessionId: \(sessionId), isValid: \(isValid))"
    }
}

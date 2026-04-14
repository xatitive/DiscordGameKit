//
//  RelationshipHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// A RelationshipHandle represents the relationship between the current user and a target
/// user on Discord. Relationships include friends, blocked users, and friend invites.
///
/// The SDK supports two types of relationships:
/// - Discord: These are relationships that persist across games and on the Discord client.
/// Both users will be able to see whether each other is online regardless of whether they are in
/// the same game or not.
/// - Game: These are per-game relationships and do not carry over to other games. The two users
/// will only be able to see if the other is online if they are playing a game in which they are
/// friends.
///
/// If someone is a game friend they can later choose to "upgrade" to a full Discord friend. In this
/// case, the user has two relationships at the same time, which is why there are two different type
/// fields on ``RelationshipHandle``. In this example, their ``RelationshipHandle/discordRelationshipType``
/// would be set to ``RelationshipType/pendingIncoming`` or ``RelationshipType/pendingOutgoing`` (based on
/// whether they are receiving or sending the invite respectively), and their
/// ``RelationshipHandle/gameRelationshipType`` would remain as ``RelationshipType/friend``.
///
/// When a user blocks another user, it is always stored on the
/// ``RelationshipHandle/discordRelationshipType`` field, and will persist across games. It is not
/// possible to block a user in only one game.
///
/// See the friends documentation for more information.
///
/// Note: While the SDK allows you to manage a user's relationships, you should never take an action
/// without their explicit consent. You should not automatically send or accept friend requests.
/// Only invoke APIs to manage relationships in response to a user action such as clicking a "Send
/// Friend Request" button.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct RelationshipHandle: DiscordObject, Identifiable, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_RelationshipHandle>
    init(storage: DiscordStorage<Discord_RelationshipHandle>) {
        self.storage = storage
    }
    
    /// ID of the target user in this relationship.
    public var id: UInt64 {
        usingLock { $0.id() }
    }

    /// Whether this relationship is a spam request.
    public var isSpamRequest: Bool {
        usingLock { $0.isSpamRequest() }
    }

    /// Type of Discord relationship.
    public var discordRelationshipType: RelationshipType {
        storage.withLock { $0.discordRelationshipType().swiftValue }
    }

    /// Type of Game relationship.
    public var gameRelationshipType: RelationshipType {
        storage.withLock { $0.gameRelationshipType().swiftValue }
    }

    /// The handle to the target user in this relationship, if one is available.
    ///
    /// This would be the user with the same ID as the one returned by ``id``
    public var user: UserHandle? {
        storage.withLock { raw -> UserHandle? in
            var handle = Discord_UserHandle()
            guard raw.user(&handle) else { return nil }
            return UserHandle(takingOwnership: handle)
        }
    }

    public var description: String {
        "RelationshipHandle(id: \(id), isSpamRequest: \(isSpamRequest), discordRelationshipType: \(discordRelationshipType), gameRelationshipType: \(gameRelationshipType), userId: \(user?.id, default: "N/A"))"
    }
}

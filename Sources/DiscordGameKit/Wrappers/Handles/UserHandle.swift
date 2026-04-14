//
//  UserHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// A UserHandle represents a single user on Discord that the SDK knows about and contains
/// basic account information for them such as id, name, and avatar, as well as their "status"
/// information which includes both whether they are online/offline/etc as well as whether they are
/// playing this game.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct UserHandle: DiscordObject, Identifiable, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_UserHandle>
    init(storage: DiscordStorage<Discord_UserHandle>) {
        self.storage = storage
    }

    /// The hash of the user's Discord profile avatar, if one is set.
    public var avatar: String? {
        storage.withLock { raw in
            var ds = Discord_String()
            guard raw.avatar(&ds) else { return nil }
            return ds.toString()
        }
    }

    /// Returns a CDN url to the user's Discord profile avatar.
    ///
    /// If the user does not have an avatar set, a url to one of Discord's default avatars is returned instead.
    public func avatarUrl(
        animatedType: AvatarType = .gif,
        staticType: AvatarType = .png
    ) -> String {
        storage.withLock { raw in
            var ds = Discord_String()
            raw.avatarUrl(
                animatedType.discordValue,
                staticType.discordValue,
                &ds
            )
            return ds.toString()
        }
    }

    /// Returns the user's preferred name, if one is set, otherwise returns their unique username.
    public var displayName: String {
        storage.withLock { raw in
            var ds = Discord_String()
            raw.displayName(&ds)
            return ds.toString()
        }
    }

    /// Returns the user's rich presence activity that is associated with the current game,
    /// if one is set.
    ///
    /// On Discord, users can have multiple rich presence activities at once, but the SDK will only
    /// expose the activity that is associated with your game. You can use this to know about the
    /// party the user is in, if any, and what the user is doing in the game.
    ///
    /// For more information see the Activity class and check out
    /// https://discord.com/developers/docs/rich-presence/overview
    public var gameActivity: Activity? {
        storage.withLock { raw -> Activity? in
            var activity = Discord_Activity()
            guard raw.gameActivity(&activity) else { return nil }
            return Activity(takingOwnership: activity)
        }
    }

    /// Returns the preferred display name of this user, if one is set.
    ///
    /// Discord's public API refers to this as a "global name" instead of "display name".
    ///
    /// Discord users can set their preferred name to almost any string.
    ///
    /// For more information about usernames on Discord, see:
    /// https://discord.com/developers/docs/resources/user
    public var globalName: String? {
        storage.withLock { raw in
            var ds = Discord_String()
            guard raw.globalName(&ds) else { return nil }
            return ds.toString()
        }
    }

    /// ID of this user.
    ///
    /// If this returns 0 then the UserHandle is no longer valid.
    public var id: UInt64 {
        usingLock { $0.id() }
    }

    /// Returns true if this user is a provisional account.
    public var isProvisional: Bool {
        usingLock { $0.isProvisional() }
    }

    /// Returns a reference to the RelationshipHandle between the currently authenticated user and this user, if any.
    public var relationship: RelationshipHandle {
        storage.withLock { raw in
            var handle = Discord_RelationshipHandle()
            raw.relationship(&handle)
            return RelationshipHandle(takingOwnership: handle)
        }
    }

    /// Returns the user's online/offline/idle status.
    public var status: StatusType {
        storage.withLock { $0.status().swiftValue }
    }

    /// Returns a list of UserApplicationProfileHandles for this user.
    ///
    /// Currently, a user can only have a single profile per application, so this list will always contain at most one ``UserApplicationProfileHandle``.
    public var userApplicationProfiles: [UserApplicationProfileHandle] {
        storage.withLock { raw in
            var span = Discord_UserApplicationProfileHandleSpan()
            raw.userApplicationProfiles(&span)
            return span.converting()
        }
    }

    /// Returns the globally unique username of this user.
    ///
    /// For provisional accounts this is an auto-generated string.
    ///
    /// For more information about usernames on Discord, see:
    /// https://discord.com/developers/docs/resources/user
    public var username: String {
        storage.withLock { raw in
            var ds = Discord_String()
            raw.username(&ds)
            return ds.toString()
        }
    }

    public var description: String {
        "UserHandle(id: \(id), username: \(username), displayName: \(displayName), globalName: \(globalName, default: "N/A"), avatar: \(avatar, default: "N/A"), isProvisional: \(isProvisional), status: \(status), gameActivity: \(gameActivity, default: "N/A"), discordRelationshipType: \(relationship.discordRelationshipType), gameRelationshipType: \(relationship.gameRelationshipType), userApplicationProfiles: \(userApplicationProfiles))"
    }
}

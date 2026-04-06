//
//  Client+Relationships.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

public extension DiscordClient {
    
    /// Accepts an incoming Discord friend request from the target user.
    ///
    /// Fails if the target user has not sent a Discord friend request to the current user, meaning
    /// that the Discord relationship type between the users must be ``RelationshipType/pendingIncoming``.
    func acceptDiscordFriendRequest(
        from userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_AcceptDiscordFriendRequest,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Accepts an incoming game friend request from the target user.
    ///
    /// Fails if the target user has not sent a game friend request to the current user, meaning
    /// that the game relationship type between the users must be ``RelationshipType/pendingIncoming``.
    func acceptGameFriendRequest(
        from userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_AcceptGameFriendRequest,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Blocks the target user so that they cannot send the user friend or activity invites
    /// and cannot message them anymore.
    ///
    /// Blocking a user will also remove any existing relationship
    /// between the two users, and persists across games, so blocking a user in one game or on
    /// Discord will block them in all other games and on Discord as well.
    func blockUser(
        _ userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_BlockUser,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Cancels an outgoing Discord friend request to the target user.
    ///
    /// Fails if a Discord friend request has not been sent to the target user, meaning
    /// that the Discord relationship type between the users must be ``RelationshipType/pendingOutgoing``.
    func cancelDiscordFriendRequest(
        to userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_CancelDiscordFriendRequest,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

	/// Cancels an outgoing game friend request to the target user.
    ///
    /// Fails if a game friend request has not been sent to the target user, meaning
    /// that the game relationship type between the users must be ``RelationshipType/pendingOutgoing``.
    func cancelGameFriendRequest(
        to userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_CancelGameFriendRequest,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Declines an incoming Discord friend request from the target user.
    ///
    /// Fails if the target user has not sent a Discord friend request to the current user, meaning
    /// that the Discord relationship type between the users must be ``RelationshipType/pendingIncoming``.
    func rejectDiscordFriendRequest(
        from userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_RejectDiscordFriendRequest,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Declines an incoming game friend request from the target user.
    ///
    /// Fails if the target user has not sent a game friend request to the current user, meaning
    /// that the game relationship type between the users must be ``RelationshipType/pendingIncoming``.
    func rejectGameFriendRequest(
        from userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_RejectGameFriendRequest,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Removes any friendship between the current user and the target user. This function will remove BOTH any Discord friendship and any game friendship between the users.
    ///
    /// Fails if the target user is not currently a Discord OR game friend with the current user.
    func removeDiscordAndGameFriend(
        _ userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_RemoveDiscordAndGameFriend,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Removes any game friendship between the current user and the target user.
    ///
    /// Fails if the target user is not currently a game friend with the current user.
    func removeGameFriend(
        _ userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_RemoveGameFriend,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Sends (or accepts) a game friend request to the target user. The target user is identified by their Discord unique username (not their DisplayName).
    ///
    /// After the friend request is sent, each user will have a new game relationship created. For
    /// the current user the ``RelationshipHandle/gameRelationshipType`` will be
    /// ``RelationshipType/pendingOutgoing`` and for the target user it will be
    /// ``RelationshipType/pendingIncoming``.
    ///
    /// If the current user already has received a game friend request from the target user
    /// (meaning ``RelationshipHandle/gameRelationshipType`` is ``RelationshipType/pendingIncoming``),
    /// then the two users will become game friends.
    ///
    /// See ``RelationshipHandle`` for more information on the difference between Discord and Game relationships.
    func sendDiscordFriendRequest(
        to username: String,
        _ body: @escaping SendFriendRequestCallback
    ) {
        let cb = CallbackBox(body)
        username.withDiscordString { str in
            usingLock(
                Discord_Client_SendDiscordFriendRequest,
                str,
                sendFriendReqTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }

    /// Sends (or accepts) a game friend request to the target user. The target user is identified by their Discord ID.
    ///
    /// After the friend request is sent, each user will have a new game relationship created. For
    /// the current user the ``RelationshipHandle/gameRelationshipType`` will be
    /// ``RelationshipType/pendingOutgoing`` and for the target user it will be
    /// ``RelationshipType/pendingIncoming``.
    ///
    /// If the current user already has received a game friend request from the target user
    /// (meaning ``RelationshipHandle/gameRelationshipType`` is ``RelationshipType/pendingIncoming``),
    /// then the two users will become game friends.
    ///
    /// See ``RelationshipHandle`` for more information on the difference between Discord and Game relationships.
    func sendDiscordFriendRequest(
        to userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_SendDiscordFriendRequestById,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Sends (or accepts) a game friend request to the target user. The target user is identified by their Discord unique username (not their DisplayName).
    ///
    /// After the friend request is sent, each user will have a new game relationship created. For
    /// the current user the ``RelationshipHandle/gameRelationshipType`` will be
    /// ``RelationshipType/pendingOutgoing`` and for the target user it will be
    /// ``RelationshipType/pendingIncoming``.
    ///
    /// If the current user already has received a game friend request from the target user
    /// (meaning ``RelationshipHandle/gameRelationshipType`` is ``RelationshipType/pendingIncoming``),
    /// then the two users will become game friends.
    ///
    /// See ``RelationshipHandle`` for more information on the difference between Discord and Game relationships.
    func sendGameFriendRequest(
        to username: String,
        _ body: @escaping SendFriendRequestCallback
    ) {
        let cb = CallbackBox(body)
        username.withDiscordString { str in
            usingLock(
                Discord_Client_SendGameFriendRequest,
                str,
                sendFriendReqTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }

    /// Sends (or accepts) a game friend request to the target user. The target user is identified by their Discord ID.
    ///
    /// After the friend request is sent, each user will have a new game relationship created. For
    /// the current user the ``RelationshipHandle/gameRelationshipType`` will be
    /// ``RelationshipType/pendingOutgoing`` and for the target user it will be
    /// ``RelationshipType/pendingIncoming``.
    ///
    /// If the current user already has received a game friend request from the target user
    /// (meaning ``RelationshipHandle/gameRelationshipType`` is ``RelationshipType/pendingIncoming``),
    /// then the two users will become game friends.
    ///
    /// See ``RelationshipHandle`` for more information on the difference between Discord and Game relationships.
    func sendGameFriendRequest(
        to userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_SendGameFriendRequestById,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Sets a callback to be invoked whenever a relationship for this user is established or changes type.
    ///
    /// This can be invoked when a user sends or accepts a friend invite or blocks a user for example.
    func onRelationshipCreated(
        _ body: @escaping RelationshipCreatedCallback
    ) {
        let ptr = setCallback(body, to: \.relationshipCreated)
        usingLock(
            Discord_Client_SetRelationshipCreatedCallback,
            relationshipCreatedTrampoline,
            nil,
            ptr
        )
    }
    
    /// Sets a callback to be invoked whenever a relationship for this user is removed, such as when the user rejects a friend request or removes a friend.
    ///
    /// When a relationship is removed, ``relationshipHandle(for:)`` will return a relationship with the type set to ``RelationshipType/none``.
    func onRelationshipDeleted(
        _ body: @escaping RelationshipDeletedCallback
    ) {
        let ptr = setCallback(body, to: \.relationshipDeleted)
        usingLock(
            Discord_Client_SetRelationshipDeletedCallback,
            relationshipDeletedTrampoline,
            nil,
            ptr
        )
    }

    /// Sets a callback to be invoked whenever the relationship groups for a user change.
    ///
    /// This is typically useful for refreshing grouped relationship UI for the affected user.
    ///
    /// - Parameter body: Callback invoked with the updated user id.
    func onRelationshipGroupsUpdated(
        _ body: @escaping RelationshipGroupsUpdatedCallback
    ) {
        let ptr = setCallback(body, to: \.relationshipGroups)
        usingLock(
            Discord_Client_SetRelationshipGroupsUpdatedCallback,
            relationshipGroupUpdate,
            nil,
            ptr
        )
    }

    /// Sets a callback to be invoked whenever a cached user is updated.
    ///
    /// - Parameter body: Callback invoked with the updated user id.
    func onUserUpdated(
        _ body: @escaping UserUpdatedCallback
    ) {
        let ptr = setCallback(body, to: \.userUpdated)
        usingLock(
            Discord_Client_SetUserUpdatedCallback,
            userUpdatedTrampoline,
            nil,
            ptr
        )
    }

    /// Unblocks the target user. Does not restore any old relationship between the users though.
    ///
    /// Fails if the target user is not currently blocked.
    func unblockUser(
        _ userId: UInt64,
        _ body: @escaping UpdateRelationshipCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_UnblockUser,
            userId,
            updateRelationshipTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }
}

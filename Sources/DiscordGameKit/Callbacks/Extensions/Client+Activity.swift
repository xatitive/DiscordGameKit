//
//  Client+Activity.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

public extension DiscordClient {
    
    /// Accepts an activity invite that the current user has received.
    ///
    /// The given callback will be invoked with the join secret for the activity, which can be used
    /// to join the user to the game's internal party system for example.
    /// This join secret comes from the other user's rich presence activity.
    func acceptActivityInvite(
        for invite: ActivityInvite,
        _ body: @escaping AcceptActivityInviteCallback
    ) {
        let cb = CallbackBox(body)
        storage.withLock { raw in	 invite.storage.withLock { invitePtr in
            Discord_Client_AcceptActivityInvite(
                &raw,
                &invitePtr,
                acceptActivityInviteTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }}
    }
    
    /// Sends a Discord activity invite to the specified user.
    ///
    /// The invite is sent as a message on Discord, which means it can be sent if any
    /// of the following are true:
    /// - Both users are online and in the game and have not blocked each other.
    /// - Both users are friends with each other.
    /// - Both users share a mutual Discord server and have previously direct messaged each other on Discord.
    ///
    /// You can optionally include message content to accompany the invite, but it is also
    /// valid to pass an empty string.
    ///
    /// - Parameters:
    ///   - id: The identifier of the recipient user.
    ///   - content: Optional message content to include with the invite.
    ///   - body: Callback invoked with the result of sending the invite.
	func sendActivityInvite(
        to id: UInt64,
        content: String,
        _ body: @escaping SendActivityInviteCallback
    ) {
        let cb = CallbackBox(body)
        content.withDiscordString { str in
            usingLock(
                Discord_Client_SendActivityInvite,
                id,
                str,
                sendActivityInviteTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Requests to join the activity of the specified user.
    ///
    /// This can be called when the target user has a rich presence activity for the current
    /// game and that activity has space for another user to join.
    ///
    /// The target user will receive an activity invite, which they can accept or reject.
    ///
    /// - Parameters:
    ///   - id: The identifier of the target user.
    ///   - body: Callback invoked with the result of sending the join request.
    func sendActivityJoinRequest(
        to id: UInt64,
        _ body: @escaping SendActivityInviteCallback
    ) {
        
    }
    
    /// When another user requests to join the current user's party, this function is called
    /// to to allow that user to join. Specifically this will send the original user an activity
    /// invite which they then need to accept again.
    func sendActivityJoinRequestReply(
        for invite: ActivityInvite,
        _ body: @escaping SendActivityInviteCallback
    ) {
        let cb = CallbackBox(body)
        storage.withLock { raw in
            invite.storage.withLock { inv in
                Discord_Client_SendActivityJoinRequestReply(
                    &raw,
                    &inv,
                    sendActivityInviteTrampoline,
                    freeBox(_:),
                    cb.retainedOpaqueValue()
                )
            }
        }
    }
    
    /// Sets a callback function that is invoked when the current user receives an activity
    /// invite from another user.
    ///
    /// These invites are always sent as messages, so the SDK is parsing these
    /// messages to look for invites and invokes this callback instead. The message create callback
    /// will not be invoked for these messages. The invite object contains all the necessary
    /// information to identity the invite, which you can later pass to ``acceptActivityInvite(for:_:)``.
    func onActivityInviteCreated(
        _ body: @escaping ActivityInviteCallback
    ) {
        let ptr = setCallback(body, to: \.activityInviteCreated)
        usingLock(
            Discord_Client_SetActivityInviteCreatedCallback,
            activityInviteTrampoline,
            freeBox,
            ptr
        )
    }
    
    /// Sets a callback function that is invoked when an existing activity invite changes.
    ///
    /// Currently, the only thing that changes on an activity invite is its validity. If the sender
    /// goes offline or exits the party the receiver was invited to, the invite is no longer
    /// joinable. It is possible for an invalid invite to go from invalid to valid if the sender
    /// rejoins the activity.
    func onActivityInviteUpdated(
        _ body: @escaping ActivityInviteCallback
    ) {
        let ptr = setCallback(body, to: \.activityInviteUpdated)
        usingLock(
            Discord_Client_SetActivityInviteUpdatedCallback,
            activityInviteTrampoline,
            freeBox,
            ptr
        )
    }
    
    /// Sets a callback function that is invoked when the current user also has Discord
    /// running on their computer and they accept an activity invite in the Discord client.
    ///
    /// This callback is invoked with the join secret from the activity rich presence, which you can
    /// use to join them to the game's internal party system. See ``Activity`` for more information on
    /// invites.
    func onActivityJoined(
        _ body: @escaping ActivityJoinCallback
    ) {
        let ptr = setCallback(body, to: \.activityJoin)
        usingLock(
            Discord_Client_SetActivityJoinCallback,
            activityJoinTrampoline,
            freeBox,
            ptr
        )
    }
    
    /// Sets a callback function that is invoked when the current user also has Discord
    /// running on their computer and they accept an activity invite in the Discord client.
    ///
    /// This callback is invoked with the join secret from the activity rich presence, which you can
    /// use to join them to the game's internal party system. See ``Activity`` for more information on invites.
    func onActivityJoinWithApp(
        _ body: @escaping ActivityJoinWithApplicationCallback
    ) {
        let ptr = setCallback(body, to: \.activityJoinWithApp)
        usingLock(
            Discord_Client_SetActivityJoinWithApplicationCallback,
            activityJoinApplicationTrampoline,
            freeBox,
            ptr
        )
    }
    
    /// Sets whether a user is online/invisible/idle/dnd on Discord.
    func setOnlineStatus(
        to status: StatusType,
        _ body: @escaping UpdateStatusCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_SetOnlineStatus,
            status.discordValue,
            updateStatusTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }
    
    /// Updates the rich presence for the current user.
    ///
    /// You should use rich presence so that other users on Discord know this user is playing a game
    /// and you can include some hints of what they are playing such as a character name or map
    /// name. Rich presence also enables Discord game invites to work too!
    ///
    /// - note: On Desktop, rich presence can be set before calling ``connect()``, but it will be
    /// cleared if the Client connects. When Client is not connected, this sets the rich presence in
    /// the current user's Discord client when available.
    ///
    /// See the docs on ``Activity``  for more details.
    ///
    /// - note: The Activity object here is a partial object, fields such as name, and applicationId
    /// cannot be set and will be overwritten by the SDK. See
    /// https://discord.com/developers/docs/rich-presence/using-with-the-game-sdk#partial-activity-struct
    /// for more information.
    func updateRichPresence(
        to activity: Activity,
        _ body: @escaping UpdateRichPresenceCallback
    ) {
        let cb = CallbackBox(body)
        storage.withLock { raw in
            activity.storage.withLock { actv in
                Discord_Client_UpdateRichPresence(
                    &raw,
                    &actv,
                    updateRichPresenceTrampoline,
                    freeBox,
                    cb.retainedOpaqueValue()
                )
            }
        }
    }
    
    
    
}

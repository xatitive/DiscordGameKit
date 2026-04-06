//
//  Client+Messages.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

extension DiscordClient {

    /// Deletes the specified message sent by the current user to the specified recipient.
    public func deleteMessage(
        to reciepientID: UInt64,
        id msgID: UInt64,
        _ body: @escaping DeleteUserMessageCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_DeleteUserMessage,
            reciepientID,
            msgID,
            deleteUserMessageTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Edits the specified message sent by the current user to the specified recipient.
    ///
    /// All of the same restrictions apply as for sending a message, see ``sendMessage(to:content:_:)`` for more.
    public func editMessage(
        to reciepientID: UInt64,
        id msgID: UInt64,
        content: String,
        _ body: @escaping EditUserMessageCallback
    ) {
        let cb = CallbackBox(body)
        content.withDiscordString { str in
            usingLock(
                Discord_Client_EditUserMessage,
                reciepientID,
                msgID,
                str,
                editUserMessageTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }

    /// Sends a direct message to the specified user.
    ///
    /// The content of the message is restricted to a maximum of 2,000 characters.
    /// See https://discord.com/developers/docs/resources/message for more details.
    ///
    /// The content of the message can also contain special markup for formatting if desired.
    /// See https://discord.com/developers/docs/reference#message-formatting for more details.
    ///
    /// A message can be sent between two users in the following situations:
    /// - Both users are online and in the game and have not blocked each other.
    /// - Both users are friends with each other.
    /// - Both users share a mutual Discord server and have previously direct messaged each other on Discord.
    ///
    /// - Parameters:
    ///   - recipientId: The identifier of the recipient user.
    ///   - content: The message content to send.
    ///   - body: Callback invoked with the result of the send operation.
    public func sendMessage(
        to recipientID: UInt64,
        content: String,
        _ body: @escaping SendUserMessageCallback
    ) {
        let cb = CallbackBox(body)
        content.withDiscordString { str in
            usingLock(
                Discord_Client_SendUserMessage,
                recipientID,
                str,
                sendUserMessageTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }

    /// Variant of ``sendMessage(to:content:_:)`` that also accepts metadata to be sent with the message.
    ///
    /// Metadata is just simple string key/value pairs.
    /// An example use case for this might be to include the name of the character that sent a
    /// message.
    public func sendMessage(
        to recipientID: UInt64,
        content: String,
        metadata: [String: String],
        _ body: @escaping SendUserMessageCallback
    ) {
        let cb = CallbackBox(body)
        content.withDiscordString { str in
            metadata.withDiscordProperties { props in
                usingLock(
                    Discord_Client_SendUserMessageWithMetadata,
                    recipientID,
                    str,
                    props,
                    sendUserMessageTrampoline,
                    freeBox,
                    cb.retainedOpaqueValue()
                )
            }
        }
    }

    /// Retrieves message conversation summaries for all users the current user has DM
    /// conversations with.
    ///
    /// The callback will be invoked with a list of UserMessageSummary objects containing:
    /// - userId: The ID of the user this conversation is with
    /// - lastMessageId: The ID of the most recent message in this conversation
    public func userMessageSummaries(_ body: @escaping UserMessageSummariesCallback) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_GetUserMessageSummaries,
            userMessageSummariesTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Retrieves messages from the direct message conversation with the specified user.
    ///
    /// Returns a list of ``MessageHandle`` representing recent messages in the conversation
    /// with the recipient, with a maximum of 200 messages and up to 72 hours of history.
    /// Messages are returned in reverse chronological order (newest first). This function
    /// checks the local cache first and only makes an HTTP request to Discord’s API if
    /// there are not enough cached messages available.
    ///
    /// If `limit` is greater than 0, it restricts the number of messages returned.
    /// If `limit` is 0 or negative, the effective limit is 200 messages and 72 hours.
    /// This behavior is intended for loading message history when users open a DM conversation.
    ///
    /// If either user has not played the game, there will be no channel between them and
    /// this function will return an ``ErrorType/httpError``.
    ///
    /// - Parameters:
    ///   - recipientID: The identifier of the recipient user.
    ///   - limit: The maximum number of messages to retrieve.
    ///   - body: Callback invoked with the resulting messages or an error.
    public func userMessages(
        to recipientID: UInt64,
        limit: Int32,
        _ body: @escaping UserMessagesWithLimitCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_GetUserMessagesWithLimit,
            recipientID,
            limit,
            userMessagesLimitedTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Opens the given message in the Discord client.
    ///
    /// This is useful when a message is sent that contains content that cannot be viewed in
    /// Discord. You can call this function in the click handler for any CTA you show to view the
    /// message in Discord.
    public func openMessageInDiscord(
        id msgID: UInt64,
        provisionalUser: @escaping ProvisionalUserMergeRequiredCallback,
        body: @escaping ClientResultCallback
    ) {
        let pCb = CallbackBox(provisionalUser)
        let bCb = CallbackBox(body)

        usingLock(
            Discord_Client_OpenMessageInDiscord,
            msgID,
            provisionalUserMergeTrampoline,
            freeBox,
            pCb.retainedOpaqueValue(),
            openMessageDiscordTrampoline,
            freeBox,
            bCb.retainedOpaqueValue(),
        )
    }

    /// Sets a callback to be invoked whenever a new message is received in either a lobby or a direct message.
    ///
    /// From the `messageId`, you can fetch the ``MessageHandle`` and then the ``ChannelHandle``
    /// to determine where the message was sent.
    ///
    /// If the user has the Discord desktop application open on the same machine as the game,
    /// they will hear notifications from the Discord application, even though they can see
    /// those messages in game. To avoid duplicate notifications, you should call
    /// ``DiscordClient/showChat(_:)`` whenever the chat is shown or hidden.
    ///
    /// - Parameter body: Callback invoked when a new message is created.
    public func onMessageCreated(
        _ body: @escaping MessageCreatedCallback
    ) {
        let ptr = setCallback(body, to: \.messageCreated)
        usingLock(
            Discord_Client_SetMessageCreatedCallback,
            messageCreatedTrampoline,
            freeBox,
            ptr
        )
    }

    /// Sets a callback to be invoked whenever a message is deleted.
    ///
    /// Some messages sent from in game, as well as all messages sent from a connected user's
    /// Discord client, can be edited and deleted in the Discord client. It is recommended to
    /// implement support for this callback so that deletions are reflected in game as well.
    ///
    /// - Parameter body: Callback invoked when a message is deleted.
    public func onMessageDeleted(
        _ body: @escaping MessageDeletedCallback
    ) {
        let ptr = setCallback(body, to: \.messageDeleted)
        usingLock(
            Discord_Client_SetMessageDeletedCallback,
            messageDeletedTrampoline,
            freeBox,
            ptr
        )
    }

    /// Sets a callback to be invoked whenever a message is edited.
    ///
    /// Some messages sent from in game, as well as all messages sent from a connected user's
    /// Discord client, can be edited and deleted in the Discord client. It is recommended to
    /// implement support for this callback so that edits are reflected in game as well.
    ///
    /// - Parameter body: Callback invoked when a message is updated.
    public func onMessageUpdated(
        _ body: @escaping MessageUpdatedCallback
    ) {
        let ptr = setCallback(body, to: \.messageUpdated)
        usingLock(
            Discord_Client_SetMessageUpdatedCallback,
            messageUpdatedTrampoline,
            freeBox,
            ptr
        )
    }

}

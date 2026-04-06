//
//  UserMessageSummary.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Represents a summary of a DM conversation with a user.
public struct UserMessageSummary: DiscordObject, Sendable {
    var storage: DiscordStorage<Discord_UserMessageSummary>
    init(storage: DiscordStorage<Discord_UserMessageSummary>) {
        self.storage = storage
    }

    /// Returns the ID of the last message sent in the DM conversation.
    public var lastMessageId: UInt64 {
        usingLock(Discord_UserMessageSummary_LastMessageId)
    }
    
	/// Returns the ID of the other user in the DM conversation.
    public var userId: UInt64 {
        usingLock(Discord_UserMessageSummary_UserId)
    }
}

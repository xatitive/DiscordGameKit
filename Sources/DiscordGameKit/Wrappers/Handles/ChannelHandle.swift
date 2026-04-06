//
//  ChannelHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// All messages sent on Discord are done so in a Channel. ``MessageHandle/channelId`` will
/// contain the ID of the channel a message was sent in, and Client::GetChannelHandle will return an
/// instance of this class.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct ChannelHandle: DiscordObject, Identifiable {
    var storage: DiscordStorage<Discord_ChannelHandle>
    init(storage: DiscordStorage<Discord_ChannelHandle>) {
        self.storage = storage
    }

    /// ID of the channel.
    public var id: UInt64 {
        usingLock(Discord_ChannelHandle_Id)
    }
    
	/// Name of the channel.
    ///
    /// Generally only channels in servers have names, although Discord may generate a display name for some channels as well.
    public var name: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_ChannelHandle_Name(&raw, &ds)
            return String(discordOwned: ds)
        }
    }

    /// For DMs and GroupDMs, returns the user IDs of the members of the channel. For all other channels returns an empty list.
    public var recipients: [UInt64] {
        storage.withLock { raw in
            var span = Discord_UInt64Span()
            Discord_ChannelHandle_Recipients(&raw, &span)
            return span.converting()
        }
    }

    /// Type of channel.
    public var type: ChannelType {
        storage.withLock { raw in
            ChannelType(
                rawValue: Int32(Discord_ChannelHandle_Type(&raw).rawValue)
            )!
        }
    }
}

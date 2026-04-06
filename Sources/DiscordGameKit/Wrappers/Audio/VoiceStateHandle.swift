//
//  VoiceStateHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// A VoiceStateHandle represents the state of a single participant in a Discord voice call.
///
/// The main use case for VoiceStateHandle in the SDK is communicate whether a user has muted or
/// defeaned themselves.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct VoiceStateHandle: DiscordObject {
    var storage: DiscordStorage<Discord_VoiceStateHandle>
    init(storage: DiscordStorage<Discord_VoiceStateHandle>) {
        self.storage = storage
    }
    
    /// Returns true if the given user has deafened themselves so that no one else in the call can hear them and so that they do not hear anyone else in the call either.
    public var selfDeaf: Bool {
        usingLock(Discord_VoiceStateHandle_SelfDeaf)
    }
    
    /// Returns true if the given user has muted themselves so that no one else in the call can hear them.
    public var selfMute: Bool {
        usingLock(Discord_VoiceStateHandle_SelfMute)
    }
    
}

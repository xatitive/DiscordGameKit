//
//  Untitled.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Represents a single input or output audio device available to the user.
///
/// Discord will initialize the audio engine with the system default input and output devices.
/// You can change the device through the Client by passing the id of the desired audio device.
public struct AudioDevice: DiscordObject, Identifiable, Sendable {
    var storage: DiscordStorage<Discord_AudioDevice>
    init(storage: DiscordStorage<Discord_AudioDevice>) {
        self.storage = storage
    }
    
    /// The ID of the audio device.
    public var id: String {
        get {
            storage.withLock {
                var ds = Discord_String()
                Discord_AudioDevice_Id(&$0, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            newValue.withDiscordString { str in
                usingLock(Discord_AudioDevice_SetId, str)
            }
        }
    }
    
    /// The display name of the audio device.
    public var name: String {
        get {
            storage.withLock {
                var ds = Discord_String()
                Discord_AudioDevice_Name(&$0, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            newValue.withDiscordString { str in
                usingLock(Discord_AudioDevice_SetName, str)
            }
        }
    }
    
    /// Whether the audio device is the system default device.
    public var isDefault: Bool {
        get { usingLock(Discord_AudioDevice_IsDefault) }
        set { usingLock(Discord_AudioDevice_SetIsDefault, newValue) }
    }
    
    public var description: String {
        "AudioDevice(id: \(id), name: \(name))"
    }
}

extension AudioDevice: Equatable {
    public static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        compare(lhs.storage, to: rhs.storage, Discord_AudioDevice_Equals)
    }
}

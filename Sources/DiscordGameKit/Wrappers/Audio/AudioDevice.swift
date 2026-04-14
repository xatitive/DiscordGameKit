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
            storage.withLock { raw in
                gettingString { span in
                    raw.id(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { buf in
                    raw.setId(span: buf)
                }
            }
        }
    }
    
    /// The display name of the audio device.
    public var name: String {
        get {
            storage.withLock { raw in
                gettingString { span in
                    raw.name(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { buf in
                    raw.setName(span: buf)
                }
            }
        }
    }
    
    /// Whether the audio device is the system default device.
    public var isDefault: Bool {
        get { usingLock { $0.isDefault() } }
        set {
            ensureUnique()
            usingLock { $0.setIsDefault(newValue) }
        }
    }
    
    public var description: String {
        "AudioDevice(id: \(id), name: \(name))"
    }
}

extension AudioDevice: Equatable {
    public static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        compare(lhs.storage, to: rhs.storage) { (lhsPtr: UnsafeMutablePointer<Discord_AudioDevice>?, rhsPtr: UnsafePointer<Discord_AudioDevice>?) -> Bool in
            guard let lhsPtr else { return false }
            return lhsPtr.pointee.equals(rhsPtr)
        }
    }
}

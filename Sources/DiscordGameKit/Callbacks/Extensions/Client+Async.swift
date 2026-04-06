//
//  Client+Async.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 4/5/26.
//

@_implementationOnly import discord_partner_sdk

#if asyncCallbacks

// ===============
// MARK: - Audio
// ===============

public extension DiscordClient {
    
    /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
    public func endCall(channel id: UInt64) async {
        await withCheckedContinuation { cont in
            endCall(channel: id) { cont.resume() }
        }
    }
    
    /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
    public func endCalls() async {
        await withCheckedContinuation { cont in
            endCalls { cont.resume() }
        }
    }
    
    
    /// Asynchronously fetches the current audio input device in use by the client.
    public func currentInputDevice() async -> AudioDevice {
        await withCheckedContinuation { cont in
            currentInputDevice { dev in
                cont.resume(returning: dev)
            }
        }
    }
    
    /// Asynchronously fetches the current audio output device in use by the client.
    public func currentOutputDevice() async -> AudioDevice {
        await withCheckedContinuation { cont in
            currentOutputDevice { dev in
                cont.resume(returning: dev)
            }
        }
    }
    
    /// Asynchronously fetches the list of audio input devices available to the user.
    public func inputDevices() async -> [AudioDevice] {
        await withCheckedContinuation { cont in
            inputDevices { devs in
                cont.resume(returning: devs)
            }
        }
    }
    
    
    /// Asynchronously fetches the list of audio output devices available to the user.
    public func outputDevices() async -> [AudioDevice] {
        await withCheckedContinuation { cont in
            outputDevices { devs in
                cont.resume(returning: devs)
            }
        }
    }
    
    
    
    
}







#endif

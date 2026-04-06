//
//  Client+AsyncVars.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 4/6/26.
//

@_implementationOnly import discord_partner_sdk

#if asyncCallbacks

public extension DiscordClient {
    
    /// Current audio input and output device in use by the client.
    var currentAudioDevice: (input: AudioDevice, output: AudioDevice) {
        get async { await (currentInputDevice, currentOutputDevice) }
    }
    
    /// Asynchronously fetches the current audio input device in use by the client.
    var currentInputDevice: AudioDevice {
        get async {
            await withCheckedContinuation { cont in
                currentInputDevice { dev in
                    cont.resume(returning: dev)
                }
            }
        }
    }

    /// Asynchronously fetches the current audio output device in use by the client.
    var currentOutputDevice: AudioDevice {
        get async {
            await withCheckedContinuation { cont in
                currentOutputDevice { dev in
                    cont.resume(returning: dev)
                }
            }
        }
    }
    
    /// List of audio input/output devices available to the user.
    var audioDevices: (input: [AudioDevice], output: [AudioDevice]) {
        get async {
            await (inputDevices, outputDevices)
        }
    }

    /// Asynchronously fetches the list of audio input devices available to the user.
    var inputDevices: [AudioDevice] {
        get async {
            await withCheckedContinuation { cont in
                inputDevices { devs in
                    cont.resume(returning: devs)
                }
            }
        }
    }

    /// Asynchronously fetches the list of audio output devices available to the user.
    var outputDevices: [AudioDevice] {
        get async {
            await withCheckedContinuation { cont in
                outputDevices { devs in
                    cont.resume(returning: devs)
                }
            }
        }
    }

    /// Checks whether the Discord mobile app is installed on this device.
    /// On desktop platforms, always returns false.
    ///
    /// This check does not require a client connection and can be called at any time.
    ///
    /// This can be used to provide UI hints to users about whether they can authorize via the
    /// Discord app, or whether they will need to use a web browser flow.
    ///
    /// Platform Requirements:
    /// - iOS: Your app must include "discord" in the LSApplicationQueriesSchemes array
    ///   in your Info.plist for this check to work correctly.
    /// - Android: Your app must include "com.discord" in the `queries` element
    ///   in your AndroidManifest.xml (required for Android 11+).
    @available(iOS 18.5, *)
    @available(Android 11.0, *)
    var isDiscordInstalled: Bool {
        get async {
            return await withCheckedContinuation { continuation in
                isDiscordInstalled { result in
                    continuation.resume(returning: result)
                }
            }
        }
    }
}

#endif

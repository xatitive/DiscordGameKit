//
//  ClientCreateOptions.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

extension DiscordClient {
    
    /// Options for creating a new ``DiscordClient`` instance.
    ///
    /// This may be used to set advanced initialization-time options on Client.
    public struct Options: DiscordObject {
        var storage: DiscordStorage<Discord_ClientCreateOptions>
        init(storage: DiscordStorage<Discord_ClientCreateOptions>) {
            self.storage = storage
        }
        
        public init() { self.storage = .init() }
        
        /// The base URL for the Discord web application.
        public var webBase: String {
            get {
                storage.withLock { raw in
                    var ds = Discord_String()
                    Discord_ClientCreateOptions_WebBase(&raw, &ds)
                    return String(discordOwned: ds)
                }
            }
            set {
                ensureUnique()
                newValue.withDiscordString { str in
                    storage.withLock { raw in
                        Discord_ClientCreateOptions_SetWebBase(&raw, str)
                    }
                }
            }
        }
        
        /// The base URL for the Discord API.
        public var apiBase: String {
            get {
                storage.withLock { raw in
                    var ds = Discord_String()
                    Discord_ClientCreateOptions_ApiBase(&raw, &ds)
                    return String(discordOwned: ds)
                }
            }
            set {
                ensureUnique()
                newValue.withDiscordString { str in
                    storage.withLock { raw in
                        Discord_ClientCreateOptions_SetApiBase(&raw, str)
                    }
                }
            }
        }
        
        /// The audio system to use. Defaults to ``AudioSystem/standard``
        ///
        /// This is an experimental API which may be removed or changed in a future release.
        ///
        /// The game audio system alters the behavior of Discord Voice on mobile platforms
        /// to use standard media-type streams instead of voice-specific audio APIs when
        /// possible. Currently this will be used on iOS 18.2+ on devices which return true
        /// from `-[AVAudioSession isEchoCancelledInputAvailable]`
        /// and on Android devices. `discordpp::AudioSystem ExperimentalAudioSystem() const;`
        /// Setter for ClientCreateOptions::ExperimentalAudioSystem.
        @available(iOS 18.2, *)
        @available(Android 11.0, *)
        public var experimentalAudioSystem: AudioSystem {
            get {
                storage.withLock { raw in
                    AudioSystem(
                        rawValue: Int32(
                            Discord_ClientCreateOptions_ExperimentalAudioSystem(&raw).rawValue
                        )
                    )!
                }
            }
            set {
                ensureUnique()
                storage.withLock { raw in
                    Discord_ClientCreateOptions_SetExperimentalAudioSystem(
                        &raw,
                        newValue.discordValue
                    )
                }
            }
        }
        
        /// Whether to prevent communications mode on Android when Bluetooth is connected.
        ///
        /// This is an experimental API which may be removed or changed in a future release.
        ///
        /// When set to true, the SDK will not enter communications mode when Bluetooth is connected.
        /// This setting is only meaningful on Android. It allows you to retain full quality stereo
        /// audio playback when in-call and avoids mixing issues caused by Bluetooth Absolute Volume,
        /// but will use the device microphone instead of the headset one
        public var experimentalAndroidPreventCommsForBluetooth: Bool {
            get {
                storage.withLock { raw in
                    Discord_ClientCreateOptions_ExperimentalAndroidPreventCommsForBluetooth(&raw)
                }
            }
            set {
                ensureUnique()
                storage.withLock { raw in
                    Discord_ClientCreateOptions_SetExperimentalAndroidPreventCommsForBluetooth(
                        &raw,
                        newValue
                    )
                }
            }
        }
        
        /// CPU affinity mask hint for certain platforms. Depending on platform support, may or may not be ignored.
        public var cpuAffinityMask: UInt64? {
            get {
                storage.withLock { raw in
                    var v: UInt64 = 0
                    return Discord_ClientCreateOptions_CpuAffinityMask(&raw, &v) ? v : nil
                }
            }
            _modify {
                ensureUnique()
                var value = self.cpuAffinityMask
                yield &value
                
                guard var value else {
                    storage.withLock { raw in
                        Discord_ClientCreateOptions_SetCpuAffinityMask(&raw, nil)
                    }
                    return
                }
                
                storage.withLock { raw in
                    Discord_ClientCreateOptions_SetCpuAffinityMask(&raw, &value)
                }
            }
        }
    }
}

//
//  Client+Audio.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

extension DiscordClient {

    /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
    public func endCall(channel id: UInt64, _ body: @escaping EndCallCallback) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_EndCall,
            id,
            endCallTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }
    
    /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
    @_disfavoredOverload
    public func endCall(channel id: UInt64) async {
        await withCheckedContinuation { cont in
            endCall(channel: id) { cont.resume() }
        }
    }
    
    /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
    public func endCalls(_ body: @escaping EndCallsCallback) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_EndCalls,
            endCallsTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }
    
    /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
    @_disfavoredOverload
    public func endCalls() async {
        await withCheckedContinuation { cont in
            endCalls { cont.resume() }
        }
    }

    /// Asynchronously fetches the current audio input device in use by the client.
    public func currentInputDevice(_ body: @escaping CurrentAudioDeviceCallback) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_GetCurrentInputDevice,
            getCurrentInputDeviceTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Asynchronously fetches the current audio input device in use by the client.
    @_disfavoredOverload
    public func currentInputDevice() async -> AudioDevice {
        await withCheckedContinuation { cont in
            currentInputDevice { dev in
                cont.resume(returning: dev)
            }
        }
    }

    /// Asynchronously fetches the current audio output device in use by the client.
    public func currentOutputDevice(
        _ body: @escaping CurrentAudioDeviceCallback
    ) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_GetCurrentOutputDevice,
            getCurrentOutputDeviceTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Asynchronously fetches the current audio output device in use by the client.
    @_disfavoredOverload
    public func currentOutputDevice() async -> AudioDevice {
        await withCheckedContinuation { cont in
            currentOutputDevice { dev in
                cont.resume(returning: dev)
            }
        }
    }

    /// Asynchronously fetches the list of audio input devices available to the user.
    public func inputDevices(_ body: @escaping InputAudioDevicesCallback) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_GetInputDevices,
            getInputDevicesTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }
    
    /// Asynchronously fetches the list of audio input devices available to the user.
    @_disfavoredOverload
    public func inputDevices() async -> [AudioDevice] {
        await withCheckedContinuation { cont in
            inputDevices { devs in
                cont.resume(returning: devs)
            }
        }
    }
    
    /// Asynchronously fetches the list of audio output devices available to the user.
    public func outputDevices(_ body: @escaping InputAudioDevicesCallback) {
        let cb = CallbackBox(body)
        usingLock(
            Discord_Client_GetOutputDevices,
            getOutputDevicesTrampoline,
            freeBox,
            cb.retainedOpaqueValue()
        )
    }

    /// Asynchronously fetches the list of audio output devices available to the user.
    @_disfavoredOverload
    public func outputDevices() async -> [AudioDevice] {
        await withCheckedContinuation { cont in
            outputDevices { devs in
                cont.resume(returning: devs)
            }
        }
    }
    
    // Persistent funcs DO NOT get an async partner, i do not have the time for that rn
    
    /// Sets a callback to be invoked when Discord detects a change in the available audio devices.
    public func onDeviceChange(_ body: @escaping AudioDeviceChangedCallback) {
        let ptr = setCallback(body, to: \.deviceChange)
        usingLock(
            Discord_Client_SetDeviceChangeCallback,
            deviceChangeTrampoline,
            nil,
            ptr
        )
    }
    
    /// Asynchronously changes the audio input device in use by the client to the specified device.
    ///
    /// You can find the list of device IDs that can be passed in with ``inputDevices(_:)``.
    public func setInputDevice(to id: String, _ body: @escaping SetAudioDeviceCallback) {
        let cb = CallbackBox(body)
        id.withDiscordString { str in
            usingLock(
                Discord_Client_SetInputDevice,
                str,
                setInputDeviceTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Asynchronously changes the audio output device in use by the client to the specified device.
    ///
    /// You can find the list of device IDs that can be passed in with ``outputDevices(_:)``.
    public func setOutputDevice(to id: String, _ body: @escaping SetAudioDeviceCallback) {
        let cb = CallbackBox(body)
        id.withDiscordString { str in
            usingLock(
                Discord_Client_SetOutputDevice,
                str,
                setOutputDeviceTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Asynchronously changes the audio input device in use by the client to the specified device.
    ///
    /// You can find the list of device IDs that can be passed in with ``inputDevices(_:)``.
    @_disfavoredOverload
    @discardableResult
    public func setInputDevice(to id: String) async -> Result<Void, ClientResult> {
        await withCheckedContinuation { cont in
            setInputDevice(to: id) { cont.resume(returning: $0) }
        }
    }
    
    /// Asynchronously changes the audio output device in use by the client to the specified device.
    ///
    /// You can find the list of device IDs that can be passed in with ``outputDevices(_:)``.
    @_disfavoredOverload
    @discardableResult
    public func setOutputDevice(to id: String) async -> Result<Void, ClientResult> {
        await withCheckedContinuation { cont in
            setOutputDevice(to: id) { cont.resume(returning: $0) }
        }
    }
    
    /// Callback invoked whenever a user in a lobby joins or leaves a voice call.
    ///
    /// The main use case for this is to enable displaying which users are in voice in a lobby
    /// even if the current user is not in voice yet, and thus does not have a Call object to bind to.
    public func onVoiceParticipantChanged(_ body: @escaping VoiceParticipantChangedCallback) {
        let cb = setCallback(body, to: \.voiceParticipant)
        usingLock(
            Discord_Client_SetVoiceParticipantChangedCallback,
        	voiceParticipantChangedTrampoline,
        	nil,
        	cb
        )
    }
    
    /// Starts or joins a call in the specified lobby.
    ///
    /// The audio received callback is invoked whenever incoming audio is received in a call. If
    /// the developer sets `outShouldMute` to true during the callback, the audio data will be muted
    /// after the callback is invoked, which is useful if the developer is utilizing the incoming
    /// audio and playing it through their own audio engine or playback. The audio samples
    /// in `data` can be modified in-place for simple DSP effects.
    ///
    /// The audio captured callback is invoked whenever local audio is captured before it is
    /// processed and transmitted which may be useful for voice moderation, etc.
    ///
    /// On iOS, your application is responsible for enabling the appropriate background audio mode
    /// in your Info.plist. VoiceBuildPostProcessor in the sample demonstrates how to do this
    /// automatically in your Unity build process.
    ///
    /// On macOS, you should set the `NSMicrophoneUsageDescription` key in your Info.plist.
    ///
    /// Returns nil if the user is already in the given voice channel.
    public func call(
        lobby id: UInt64,
    	received: @escaping UserAudioReceivedCallback,
        captured: @escaping UserAudioCapturedCallback
    ) -> DiscordCall? {
        let (rec, cap) = (setCallback(received, to: \.audioReceived), setCallback(captured,to: \.audioCaptured))
        
        let call = storage.withLock { raw -> DiscordCall? in
            var call = Discord_Call()
            return Discord_Client_StartCallWithAudioCallbacks(
                &raw,
                id,
                userAudioReceivedTrampoline,
                nil,
                rec,
                userAudioRCapturedTrampoline,
                nil,
                cap,
                &call
            ) ? DiscordCall(takingOwnership: call) : nil
        } // TODO: Check this?
        
        return call
    }
    
    /// Threshold that can be set to indicate when no audio is being received by the user's mic.
    ///
    /// An example of when this may be useful: When push to talk is being used and the user pushes
    /// their talk key, but something is configured wrong and no audio is being received, this
    /// threshold and callback can be used to detect that situation and notify the user. The
    /// threshold is specified in DBFS, or decibels relative to full scale, and the range is
    /// [-100.0, 100.0] It defaults to -100.0, so is disabled.
    public func onNoAudioInput(_ body: @escaping NoAudioInputCallback) {
        let ptr = setCallback(body, to: \.noAudioInput)
        usingLock(
            Discord_Client_SetNoAudioInputCallback,
            noAudioTrampoline,
        	nil,
            ptr
        )
    }
    
    
}

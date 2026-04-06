//
//  DiscordCall.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

public final class DiscordCall: DiscordObject {
    var storage: DiscordStorage<Discord_Call>
    
    init(storage: DiscordStorage<Discord_Call>) {
        self.storage = storage
    }
    
    /// Returns the current call status.
    ///
    /// A call is not ready to be used until the status changes to "Connected".
    public var status: CallStatus {
        usingLock(Discord_Call_GetStatus).swiftValue
    }
    
    /// Returns the ID of the lobby with which this call is associated.
    public var channelId: UInt64 {
        usingLock(Discord_Call_GetChannelId)
    }
    
    /// Returns the ID of the lobby with which this call is associated.
    public var guildId: UInt64 {
        usingLock(Discord_Call_GetGuildId)
    }
    
    /// Returns whether the current user's microphone is muted.
    ///
    /// Mutes the current user's microphone so that no other participant in their active calls can hear them.
    public var selfMute: Bool {
        get { usingLock(Discord_Call_GetSelfMute) }
        set { usingLock(Discord_Call_SetSelfMute, newValue) }
    }
    
    /// Mutes all audio from the currently active call for the current user.
    ///
    /// They will not be able to hear any other participants, and no other participants will be able to hear the current user either.
    public var selfDeaf: Bool {
        get { usingLock(Discord_Call_GetSelfDeaf) }
        set { usingLock(Discord_Call_SetSelfDeaf, newValue) }
    }
    
    /// Whether to use voice auto detection or push to talk for the current user on this call.
    ///
    /// If using push to talk you should set ``pttActive`` to true whenever the user presses their configured push to talk key.
    public var audioMode: AudioModeType {
        get { usingLock(Discord_Call_GetAudioMode).swiftValue }
        set { usingLock(Discord_Call_SetAudioMode, newValue.discordValue) }
    }
    
    /// Returns whether push to talk is currently active, meaning the user is currently pressing their configured push to talk key.
    ///
    /// When push to talk is enabled, this should be called whenever the user pushes or
    /// releases their configured push to talk key. This key must be configured in the game, the SDK
	/// does not handle keybinds itself.
    public var pttActive: Bool {
        get { usingLock(Discord_Call_GetPTTActive) }
        set { usingLock(Discord_Call_SetPTTActive, newValue) }
    }
    
    /// Returns the time that PTT is active after the user releases the PTT key and is set to false.
    ///
    /// Defaults to no release delay, but we recommend setting to 20ms, which is what Discord uses.
    public var pttReleaseDelay: UInt32 {
        get { usingLock(Discord_Call_GetPTTReleaseDelay) }
        set { usingLock(Discord_Call_SetPTTReleaseDelay, newValue) }
    }

    /// Returns a list of all of the user IDs of the participants in the call.
    public var participants: [UInt64] {
        storage.withLock { raw in
            var span = Discord_UInt64Span()
            Discord_Call_GetParticipants(&raw, &span)
            return span.converting()
        }
    }
    
    // MARK: - Methods
    
    /// Returns whether the current user has locally muted the given userId for themselves.
    public func getLocalMute(for userId: UInt64) -> Bool {
        usingLock(Discord_Call_GetLocalMute, userId)
    }
    
    /// Locally mutes the given userId, so that the current user cannot hear them anymore.
    ///
    /// Does not affect whether the given user is muted for any other connected clients.
    public func setLocalMute(for userId: UInt64, _ mute: Bool) {
        usingLock(Discord_Call_SetLocalMute, userId, mute)
    }
    
    /// Returns the locally set playout volume of the given userId.
    ///
    /// Does not affect the volume of this user for any other connected clients. The range of volume
    /// is [0, 200], where 100 indicate default audio volume of the playback device.
    public func getParticipantVolume(for userId: UInt64) -> Float {
        usingLock(Discord_Call_GetParticipantVolume, userId)
    }
    
    /// Locally changes the playout volume of the given id.
    ///
    /// Does not affect the volume of this user for any other connected clients. The range of volume
    /// is [0, 200], where 100 indicate default audio volume of the playback device.
    public func setParticipantVolume(for userId: UInt64, _ volume: Float) {
        usingLock(Discord_Call_SetParticipantVolume, userId, volume)
    }
    
    /// Returns the current configuration for void auto detection thresholds.
    /// - seealso: ``setVADThreshold(automatic:threshold:)``
    public func VADThreshold() -> VADThresholdSettings {
        storage.withLock { raw in
            var settings = Discord_VADThresholdSettings()
            Discord_Call_GetVADThreshold(&raw, &settings)
            return VADThresholdSettings(takingOwnership: settings)
        }
    }
    
    /// Customizes the void auto detection thresholds for picking up activity from a user's mic.
    ///
    /// - When automatic is set to True, Discord will automatically detect the appropriate threshold to use.
    /// - When automatic is set to False, the given threshold value will be used. Threshold has a range of -100, 0, and defaults to -60.
    public func setVADThreshold(automatic: Bool, threshold: Float) {
        usingLock(Discord_Call_SetVADThreshold, automatic, threshold)
    }
    
    /// Returns a reference to the VoiceStateHandle for the user ID of the given call participant.
    ///
    /// The VoiceStateHandle allows other users to know if the target user has muted or deafened themselves.
    public func getVoiceStateHandle(for userId: UInt64) -> VoiceStateHandle? {
        storage.withLock { raw -> VoiceStateHandle? in
            var handle = Discord_VoiceStateHandle()
            guard Discord_Call_GetVoiceStateHandle(&raw, userId, &handle) else { return nil }
            return VoiceStateHandle(takingOwnership: handle)
        }
    }
    
    // MARK: - Callback Closure Storage
    
    internal var persistent = PersistentCallbacks()
}

extension DiscordCall {
    struct PersistentCallbacks {
        var voiceStateChanged = CallbackBox<VoiceStateChanged>()
        var participantChanged = CallbackBox<ParticipantChanged>()
        var speakingStatusChanged = CallbackBox<SpeakingStatusChanged>()
        var statusChanged = CallbackBox<StatusChanged>()
    }
    
    func setCallback<T>(_ cb: T, to kp: WritableKeyPath<PersistentCallbacks, CallbackBox<T>>) -> UnsafeMutableRawPointer {
        persistent[keyPath: kp].callback = cb
        return persistent[keyPath: kp].unretainedOpaqueValue()
    }
}

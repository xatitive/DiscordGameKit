//
//  Call+Extensions.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

public extension DiscordCall {
    
    /// Callback function for ``onVoiceStateChanged(_:)``
    typealias VoiceStateChanged = (_ userId: UInt64) -> Void
    
    /// Callback function for ``onParticipantChanged(_:)``
    typealias ParticipantChanged = (_ userId: UInt64, _ added: Bool) -> Void
    
    /// Callback function for ``onSpeakingStatusChanged(_:)``
    typealias SpeakingStatusChanged = (_ userId: UInt64, _ playingSound: Bool) -> Void
    
    /// /// Callback function for ``onStatusChanged(_:)``
    typealias StatusChanged = (_ status: CallStatus, _ error: CallError, _ errDetail: Int32) -> Void
    
}

let voiceStateTrampoline: Discord_Call_OnVoiceStateChanged = { id, ctx in
    CallbackBox<DiscordCall.VoiceStateChanged>.from(opaque: ctx)?(id)
}

let participantChangedTrampoline: Discord_Call_OnParticipantChanged = { id, added, ctx in
    CallbackBox<DiscordCall.ParticipantChanged>.from(opaque: ctx)?(id, added)
}

let speakingStatusChangedTrampoline: Discord_Call_OnSpeakingStatusChanged = { id, playing, ctx in
    CallbackBox<DiscordCall.SpeakingStatusChanged>.from(opaque: ctx)?(id, playing)
}

let callStatusChangedTrampoline: Discord_Call_OnStatusChanged = { status, error, errDetail, ctx in
    CallbackBox<DiscordCall.StatusChanged>.from(opaque: ctx)?(
        status.swiftValue,
        error.swiftValue,
        errDetail
    )
}

public extension DiscordCall {
    
    /// Sets a callback to generally be invoked whenever a field on a VoiceStateHandle object for a user would have changed.
    ///
    /// For example when a user mutes themselves, all other connected clients will invoke the
    /// ``DiscordCall/VoiceStateChanged`` callback, because the "self mute" field will be true now. The callback is
    /// generally not invoked when users join or leave channels.
    func onVoiceStateChanged(
        _ body: @escaping VoiceStateChanged
    ) {
        let ptr = setCallback(body, to: \.voiceStateChanged)
        usingLock(
            Discord_Call_SetOnVoiceStateChangedCallback,
            voiceStateTrampoline,
            nil,
            ptr
        )
    }
    
    /// Sets a callback to be invoked whenever some joins or leaves a voice call.
    func onParticipantChanged(
        _ body: @escaping ParticipantChanged
    ) {
        let ptr = setCallback(body, to: \.participantChanged)
        usingLock(
            Discord_Call_SetParticipantChangedCallback,
            participantChangedTrampoline,
            nil,
            ptr
        )
    }
    
    /// Sets a callback to be invoked whenever a user starts or stops speaking and is passed in the userId and whether they are currently speaking.
    ///
    /// It can be invoked in other cases as well, such as if the priority speaker changes or if the user plays a soundboard sound.
    func onSpeakingStatusChanged(
        _ body: @escaping SpeakingStatusChanged
    ) {
        let ptr = setCallback(body, to: \.speakingStatusChanged)
        usingLock(
            Discord_Call_SetSpeakingStatusChangedCallback,
            speakingStatusChangedTrampoline,
            nil,
            ptr
        )
    }
    
    /// Sets a callback to be invoked when the call status changes, such as when it fully connects or starts reconnecting.
    func onStatusChanged(
        _ body: @escaping StatusChanged
    ) {
        let ptr = setCallback(body, to: \.statusChanged)
        usingLock(
            Discord_Call_SetStatusChangedCallback,
            callStatusChangedTrampoline,
            nil,
            ptr
        )
    }
    
    
}

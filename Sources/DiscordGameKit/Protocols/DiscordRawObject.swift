//
//  DiscordObject.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 3/20/26.
//

@_implementationOnly import discord_partner_sdk

internal protocol DiscordRawObject {
    mutating func drop()
    init()
}

internal protocol DiscordRawCopyable: DiscordRawObject {
    mutating func copy(into other: inout Self)
}

// ═══════════════════════════════════════════════════════════════
// MARK: - Init + Drop + Clone
// ═══════════════════════════════════════════════════════════════

extension Discord_ActivityAssets:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_ActivityAssets_Init(&self) }
     mutating func drop()                { Discord_ActivityAssets_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ActivityAssets_Clone(&other, $0) }
    }
}

extension Discord_ActivityTimestamps:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_ActivityTimestamps_Init(&self) }
     mutating func drop()                { Discord_ActivityTimestamps_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ActivityTimestamps_Clone(&other, $0) }
    }
}

extension Discord_ActivityParty:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_ActivityParty_Init(&self) }
     mutating func drop()                { Discord_ActivityParty_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ActivityParty_Clone(&other, $0) }
    }
}

extension Discord_ActivitySecrets:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_ActivitySecrets_Init(&self) }
     mutating func drop()                { Discord_ActivitySecrets_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ActivitySecrets_Clone(&other, $0) }
    }
}

extension Discord_ActivityButton:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_ActivityButton_Init(&self) }
     mutating func drop()                { Discord_ActivityButton_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ActivityButton_Clone(&other, $0) }
    }
}

extension Discord_Activity:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_Activity_Init(&self) }
     mutating func drop()                { Discord_Activity_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_Activity_Clone(&other, $0) }
    }
}

extension Discord_AuthorizationArgs:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_AuthorizationArgs_Init(&self) }
     mutating func drop()                { Discord_AuthorizationArgs_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_AuthorizationArgs_Clone(&other, $0) }
    }
}

extension Discord_DeviceAuthorizationArgs:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_DeviceAuthorizationArgs_Init(&self) }
     mutating func drop()                { Discord_DeviceAuthorizationArgs_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_DeviceAuthorizationArgs_Clone(&other, $0) }
    }
}

extension Discord_LinkedLobby:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_LinkedLobby_Init(&self) }
     mutating func drop()                { Discord_LinkedLobby_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_LinkedLobby_Clone(&other, $0) }
    }
}

extension Discord_AdditionalContent:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_AdditionalContent_Init(&self) }
     mutating func drop()                { Discord_AdditionalContent_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_AdditionalContent_Clone(&other, $0) }
    }
}

extension Discord_ClientCreateOptions:  DiscordRawCopyable {
     init()                              { self.init(opaque: nil); Discord_ClientCreateOptions_Init(&self) }
     mutating func drop()                { Discord_ClientCreateOptions_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ClientCreateOptions_Clone(&other, $0) }
    }
}

// ═══════════════════════════════════════════════════════════════
// MARK: - Init + Drop (no Clone)
// ═══════════════════════════════════════════════════════════════

extension Discord_AuthorizationCodeChallenge:  DiscordRawCopyable {
     init()                { self.init(opaque: nil); Discord_AuthorizationCodeChallenge_Init(&self) }
     mutating func drop()  { Discord_AuthorizationCodeChallenge_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_AuthorizationCodeChallenge_Clone(&other, $0) }
    }
}

extension Discord_Client: DiscordRawObject {
     init()                { self.init(opaque: nil); Discord_Client_Init(&self) }
     mutating func drop()  { Discord_Client_Drop(&self) }
}

// ═══════════════════════════════════════════════════════════════
// MARK: - Drop + Clone (no Init — arrives pre-initialized)
// ═══════════════════════════════════════════════════════════════

extension Discord_ClientResult: DiscordRawCopyable  {
     mutating func drop()                { Discord_ClientResult_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ClientResult_Clone(&other, $0) }
    }
}

extension Discord_VoiceStateHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_VoiceStateHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_VoiceStateHandle_Clone(&other, $0) }
    }
}

// Discord_Call_Clone takes a non-const second arg — needs mutablePointer
extension Discord_Call: DiscordRawCopyable  {
     mutating func drop()                { Discord_Call_Drop(&self) }
     mutating func copy(into other: inout Self)   {
        withUnsafeMutablePointer(to: &self) { Discord_Call_Clone(&other, $0) }
    }
}

extension Discord_ChannelHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_ChannelHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_ChannelHandle_Clone(&other, $0) }
    }
}

extension Discord_GuildMinimal: DiscordRawCopyable  {
     mutating func drop()                { Discord_GuildMinimal_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_GuildMinimal_Clone(&other, $0) }
    }
}

extension Discord_GuildChannel: DiscordRawCopyable  {
     mutating func drop()                { Discord_GuildChannel_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_GuildChannel_Clone(&other, $0) }
    }
}

extension Discord_LinkedChannel: DiscordRawCopyable  {
     mutating func drop()                { Discord_LinkedChannel_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_LinkedChannel_Clone(&other, $0) }
    }
}

extension Discord_RelationshipHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_RelationshipHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_RelationshipHandle_Clone(&other, $0) }
    }
}

extension Discord_UserApplicationProfileHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_UserApplicationProfileHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_UserApplicationProfileHandle_Clone(&other, $0) }
    }
}

extension Discord_UserHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_UserHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_UserHandle_Clone(&other, $0) }
    }
}

extension Discord_LobbyMemberHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_LobbyMemberHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_LobbyMemberHandle_Clone(&other, $0) }
    }
}

extension Discord_LobbyHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_LobbyHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_LobbyHandle_Clone(&other, $0) }
    }
}

extension Discord_MessageHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_MessageHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_MessageHandle_Clone(&other, $0) }
    }
}

extension Discord_AudioDevice: DiscordRawCopyable  {
     mutating func drop()                { Discord_AudioDevice_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_AudioDevice_Clone(&other, $0) }
    }
}

extension Discord_UserMessageSummary: DiscordRawCopyable  {
     mutating func drop()                { Discord_UserMessageSummary_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_UserMessageSummary_Clone(&other, $0) }
    }
}

extension Discord_CallInfoHandle: DiscordRawCopyable  {
     mutating func drop()                { Discord_CallInfoHandle_Drop(&self) }
     func copy(into other: inout Self)   {
        withUnsafePointer(to: self) { Discord_CallInfoHandle_Clone(&other, $0) }
    }
}

// ═══════════════════════════════════════════════════════════════
// MARK: - Drop only
// ═══════════════════════════════════════════════════════════════

extension Discord_VADThresholdSettings: DiscordRawObject  {
     mutating func drop() { Discord_VADThresholdSettings_Drop(&self) }
}

// forgot these

extension Discord_ActivityInvite:  DiscordRawCopyable {
     init()                                    { self.init(opaque: nil); Discord_ActivityInvite_Init(&self) }
     mutating func drop()                      { Discord_ActivityInvite_Drop(&self) }
     mutating func copy(into other: inout Self) {
        withUnsafePointer(to: self) { Discord_ActivityInvite_Clone(&other, $0) }
    }
}

extension Discord_AuthorizationCodeVerifier: DiscordRawCopyable  {
     mutating func drop()                      { Discord_AuthorizationCodeVerifier_Drop(&self) }
     mutating func copy(into other: inout Self) {
        withUnsafePointer(to: self) { Discord_AuthorizationCodeVerifier_Clone(&other, $0) }
    }
}

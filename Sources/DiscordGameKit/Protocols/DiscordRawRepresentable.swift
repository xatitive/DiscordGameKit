//
//  DiscordRawRepresentable.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 3/20/26.
//

@_implementationOnly import discord_partner_sdk

// MARK: - Protocol

protocol DiscordRawRepresentable: RawRepresentable where RawValue == Int32 {
    associatedtype DiscordType: RawRepresentable where DiscordType.RawValue == UInt32
    var discordValue: DiscordType { get }
}

extension DiscordRawRepresentable {
    /// Default implementation — just reinterprets the Int32 as UInt32
    @inlinable
    var discordValue: DiscordType {
        get { DiscordType(rawValue: UInt32(rawValue))! }
        set { self = .init(rawValue: Int32(newValue.rawValue))! }
    }
}

// MARK: - Enum Conformances

extension ActivityActionType:               DiscordRawRepresentable { typealias DiscordType = Discord_ActivityActionTypes }
extension ActivityPartyPrivacy:             DiscordRawRepresentable { typealias DiscordType = Discord_ActivityPartyPrivacy }
extension ActivityType:                     DiscordRawRepresentable { typealias DiscordType = Discord_ActivityTypes }
extension StatusDisplayType:                DiscordRawRepresentable { typealias DiscordType = Discord_StatusDisplayTypes }
extension ErrorType:                        DiscordRawRepresentable { typealias DiscordType = Discord_ErrorType }
extension HttpStatusCode:                   DiscordRawRepresentable { typealias DiscordType = Discord_HttpStatusCode }
extension AuthenticationCodeChallengeMethod:DiscordRawRepresentable { typealias DiscordType = Discord_AuthenticationCodeChallengeMethod }
extension IntegrationType:                  DiscordRawRepresentable { typealias DiscordType = Discord_IntegrationType }
extension ChannelType:                      DiscordRawRepresentable { typealias DiscordType = Discord_ChannelType }
extension AdditionalContentType:            DiscordRawRepresentable { typealias DiscordType = Discord_AdditionalContentType }
extension AudioSystem:                      DiscordRawRepresentable { typealias DiscordType = Discord_AudioSystem }
extension CallError:                        DiscordRawRepresentable { typealias DiscordType = Discord_Call_Error }
extension AudioModeType:                    DiscordRawRepresentable { typealias DiscordType = Discord_AudioModeType }
extension CallStatus:                       DiscordRawRepresentable { typealias DiscordType = Discord_Call_Status }
extension RelationshipType:                 DiscordRawRepresentable { typealias DiscordType = Discord_RelationshipType }
extension ExternalIdentityProviderType:     DiscordRawRepresentable { typealias DiscordType = Discord_ExternalIdentityProviderType }
extension AvatarType:                       DiscordRawRepresentable { typealias DiscordType = Discord_UserHandle_AvatarType }
extension StatusType:                       DiscordRawRepresentable { typealias DiscordType = Discord_StatusType }
extension DisclosureType:                   DiscordRawRepresentable { typealias DiscordType = Discord_DisclosureTypes }
extension ClientError:                      DiscordRawRepresentable { typealias DiscordType = Discord_Client_Error }
extension ClientStatus:                     DiscordRawRepresentable { typealias DiscordType = Discord_Client_Status }
extension ClientThread:                     DiscordRawRepresentable { typealias DiscordType = Discord_Client_Thread }
extension AuthorizationTokenType:           DiscordRawRepresentable { typealias DiscordType = Discord_AuthorizationTokenType }
extension AuthenticationExternalAuthType:   DiscordRawRepresentable { typealias DiscordType = Discord_AuthenticationExternalAuthType }
extension LoggingSeverity:                  DiscordRawRepresentable { typealias DiscordType = Discord_LoggingSeverity }
extension RelationshipGroupType:            DiscordRawRepresentable { typealias DiscordType = Discord_RelationshipGroupType }
extension ActivityGamePlatform:             DiscordRawRepresentable { typealias DiscordType = Discord_ActivityGamePlatforms }


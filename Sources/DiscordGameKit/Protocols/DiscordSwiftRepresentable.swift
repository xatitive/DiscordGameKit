//
//  DiscordSwiftRepresentable.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 4/5/26.
//

@_implementationOnly import discord_partner_sdk

protocol DiscordSwiftRepresentable: RawRepresentable where RawValue == UInt32 {
    associatedtype SwiftType: RawRepresentable where SwiftType.RawValue == Int32
    var swiftValue: SwiftType { get set }
}

extension DiscordSwiftRepresentable {
    @inlinable
    var swiftValue: SwiftType {
        get { SwiftType(rawValue: Int32(rawValue))! }
        set { self = .init(rawValue: UInt32(newValue.rawValue))! }
    }
}

extension Discord_ActivityActionTypes:                 DiscordSwiftRepresentable { typealias SwiftType = ActivityActionType }
extension Discord_ActivityPartyPrivacy:                DiscordSwiftRepresentable { typealias SwiftType = ActivityPartyPrivacy }
extension Discord_ActivityTypes:                       DiscordSwiftRepresentable { typealias SwiftType = ActivityType }
extension Discord_StatusDisplayTypes:                  DiscordSwiftRepresentable { typealias SwiftType = StatusDisplayType }
extension Discord_ErrorType:                           DiscordSwiftRepresentable { typealias SwiftType = ErrorType }
extension Discord_HttpStatusCode:                      DiscordSwiftRepresentable { typealias SwiftType = HttpStatusCode }
extension Discord_AuthenticationCodeChallengeMethod:   DiscordSwiftRepresentable { typealias SwiftType = AuthenticationCodeChallengeMethod }
extension Discord_IntegrationType:                     DiscordSwiftRepresentable { typealias SwiftType = IntegrationType }
extension Discord_ChannelType:                         DiscordSwiftRepresentable { typealias SwiftType = ChannelType }
extension Discord_AdditionalContentType:               DiscordSwiftRepresentable { typealias SwiftType = AdditionalContentType }
extension Discord_AudioSystem:                         DiscordSwiftRepresentable { typealias SwiftType = AudioSystem }
extension Discord_Call_Error:                          DiscordSwiftRepresentable { typealias SwiftType = CallError }
extension Discord_AudioModeType:                       DiscordSwiftRepresentable { typealias SwiftType = AudioModeType }
extension Discord_Call_Status:                         DiscordSwiftRepresentable { typealias SwiftType = CallStatus }
extension Discord_RelationshipType:                    DiscordSwiftRepresentable { typealias SwiftType = RelationshipType }
extension Discord_ExternalIdentityProviderType:        DiscordSwiftRepresentable { typealias SwiftType = ExternalIdentityProviderType }
extension Discord_UserHandle_AvatarType:               DiscordSwiftRepresentable { typealias SwiftType = AvatarType }
extension Discord_StatusType:                          DiscordSwiftRepresentable { typealias SwiftType = StatusType }
extension Discord_DisclosureTypes:                     DiscordSwiftRepresentable { typealias SwiftType = DisclosureType }
extension Discord_Client_Error:                        DiscordSwiftRepresentable { typealias SwiftType = ClientError }
extension Discord_Client_Status:                       DiscordSwiftRepresentable { typealias SwiftType = ClientStatus }
extension Discord_Client_Thread:                       DiscordSwiftRepresentable { typealias SwiftType = ClientThread }
extension Discord_AuthorizationTokenType:              DiscordSwiftRepresentable { typealias SwiftType = AuthorizationTokenType }
extension Discord_AuthenticationExternalAuthType:      DiscordSwiftRepresentable { typealias SwiftType = AuthenticationExternalAuthType }
extension Discord_LoggingSeverity:                     DiscordSwiftRepresentable { typealias SwiftType = LoggingSeverity }
extension Discord_RelationshipGroupType:               DiscordSwiftRepresentable { typealias SwiftType = RelationshipGroupType }
extension Discord_ActivityGamePlatforms:               DiscordSwiftRepresentable { typealias SwiftType = ActivityGamePlatform }

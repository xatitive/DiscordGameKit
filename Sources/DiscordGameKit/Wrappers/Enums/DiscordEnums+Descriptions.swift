//
//  DiscordEnums+Descriptions.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 3/20/26.
//

@_implementationOnly import discord_partner_sdk

// ═══════════════════════════════════════════════════════════════
// MARK: ENUMS — C API backed (Discord_XxxToString exists)
// ═══════════════════════════════════════════════════════════════

extension CallError: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_Call_ErrorToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

extension CallStatus: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_Call_StatusToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

extension AvatarType: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_UserHandle_AvatarTypeToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

extension AdditionalContentType: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_AdditionalContent_TypeToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

extension ClientError: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_Client_ErrorToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

extension ClientStatus: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_Client_StatusToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

extension ClientThread: CustomStringConvertible {
    public var description: String {
        var raw = Discord_String(ptr: nil, size: 0)
        Discord_Client_ThreadToString(discordValue, &raw)
        return String(discordOwned: raw)
    }
}

// ═══════════════════════════════════════════════════════════════
// MARK: ENUMS — Swift switch (no C ToString, mirrors EnumToString)
// ═══════════════════════════════════════════════════════════════

extension ActivityActionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalid:     return "Invalid"
        case .join:        return "Join"
        case .joinRequest: return "JoinRequest"
        }
    }
}

extension ActivityPartyPrivacy: CustomStringConvertible {
    public var description: String {
        switch self {
        case .private: return "Private"
        case .public:  return "Public"
        }
    }
}

extension ActivityType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .playing:      return "Playing"
        case .streaming:    return "Streaming"
        case .listening:    return "Listening"
        case .watching:     return "Watching"
        case .customStatus: return "CustomStatus"
        case .competing:    return "Competing"
        case .hangStatus:   return "HangStatus"
        }
    }
}

extension StatusDisplayType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name:    return "Name"
        case .state:   return "State"
        case .details: return "Details"
        }
    }
}

extension ActivityGamePlatform: CustomStringConvertible {
    public var description: String {
        var parts: [String] = []
        if self.rawValue & ActivityGamePlatform.desktop.rawValue  != 0 { parts.append("Desktop") }
        if self.rawValue & ActivityGamePlatform.xbox.rawValue     != 0 { parts.append("Xbox") }
        if self.rawValue & ActivityGamePlatform.samsung.rawValue  != 0 { parts.append("Samsung") }
        if self.rawValue & ActivityGamePlatform.iOS.rawValue      != 0 { parts.append("IOS") }
        if self.rawValue & ActivityGamePlatform.android.rawValue  != 0 { parts.append("Android") }
        if self.rawValue & ActivityGamePlatform.embedded.rawValue != 0 { parts.append("Embedded") }
        if self.rawValue & ActivityGamePlatform.ps4.rawValue      != 0 { parts.append("PS4") }
        if self.rawValue & ActivityGamePlatform.ps5.rawValue      != 0 { parts.append("PS5") }
        return parts.isEmpty ? "unknown" : parts.joined(separator: "|")
    }
}

extension ErrorType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:                return "None"
        case .networkError:        return "NetworkError"
        case .httpError:           return "HTTPError"
        case .clientNotReady:      return "ClientNotReady"
        case .disabled:            return "Disabled"
        case .clientDestroyed:     return "ClientDestroyed"
        case .validationError:     return "ValidationError"
        case .aborted:             return "Aborted"
        case .authorizationFailed: return "AuthorizationFailed"
        case .rpcError:            return "RPCError"
        }
    }
}

extension HttpStatusCode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:                         return "None"
        case .continue:                     return "Continue"
        case .switchingProtocols:           return "SwitchingProtocols"
        case .processing:                   return "Processing"
        case .earlyHints:                   return "EarlyHints"
        case .ok:                           return "Ok"
        case .created:                      return "Created"
        case .accepted:                     return "Accepted"
        case .nonAuthoritativeInfo:         return "NonAuthoritativeInfo"
        case .noContent:                    return "NoContent"
        case .resetContent:                 return "ResetContent"
        case .partialContent:               return "PartialContent"
        case .multiStatus:                  return "MultiStatus"
        case .alreadyReported:              return "AlreadyReported"
        case .imUsed:                       return "ImUsed"
        case .multipleChoices:              return "MultipleChoices"
        case .movedPermanently:             return "MovedPermanently"
        case .found:                        return "Found"
        case .seeOther:                     return "SeeOther"
        case .notModified:                  return "NotModified"
        case .temporaryRedirect:            return "TemporaryRedirect"
        case .permanentRedirect:            return "PermanentRedirect"
        case .badRequest:                   return "BadRequest"
        case .unauthorized:                 return "Unauthorized"
        case .paymentRequired:              return "PaymentRequired"
        case .forbidden:                    return "Forbidden"
        case .notFound:                     return "NotFound"
        case .methodNotAllowed:             return "MethodNotAllowed"
        case .notAcceptable:                return "NotAcceptable"
        case .proxyAuthRequired:            return "ProxyAuthRequired"
        case .requestTimeout:               return "RequestTimeout"
        case .conflict:                     return "Conflict"
        case .gone:                         return "Gone"
        case .lengthRequired:               return "LengthRequired"
        case .preconditionFailed:           return "PreconditionFailed"
        case .payloadTooLarge:              return "PayloadTooLarge"
        case .uriTooLong:                   return "UriTooLong"
        case .unsupportedMediaType:         return "UnsupportedMediaType"
        case .rangeNotSatisfiable:          return "RangeNotSatisfiable"
        case .expectationFailed:            return "ExpectationFailed"
        case .misdirectedRequest:           return "MisdirectedRequest"
        case .unprocessableEntity:          return "UnprocessableEntity"
        case .locked:                       return "Locked"
        case .failedDependency:             return "FailedDependency"
        case .tooEarly:                     return "TooEarly"
        case .upgradeRequired:              return "UpgradeRequired"
        case .preconditionRequired:         return "PreconditionRequired"
        case .tooManyRequests:              return "TooManyRequests"
        case .requestHeaderFieldsTooLarge:  return "RequestHeaderFieldsTooLarge"
        case .internalServerError:          return "InternalServerError"
        case .notImplemented:               return "NotImplemented"
        case .badGateway:                   return "BadGateway"
        case .serviceUnavailable:           return "ServiceUnavailable"
        case .gatewayTimeout:               return "GatewayTimeout"
        case .httpVersionNotSupported:      return "HttpVersionNotSupported"
        case .variantAlsoNegotiates:        return "VariantAlsoNegotiates"
        case .insufficientStorage:          return "InsufficientStorage"
        case .loopDetected:                 return "LoopDetected"
        case .notExtended:                  return "NotExtended"
        case .networkAuthorizationRequired: return "NetworkAuthorizationRequired"
        }
    }
}

extension AuthenticationCodeChallengeMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .s256: return "S256"
        }
    }
}

extension IntegrationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .guildInstall: return "GuildInstall"
        case .userInstall:  return "UserInstall"
        }
    }
}

extension ChannelType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .guildText:          return "GuildText"
        case .dm:                 return "Dm"
        case .guildVoice:         return "GuildVoice"
        case .groupDm:            return "GroupDm"
        case .guildCategory:      return "GuildCategory"
        case .guildNews:          return "GuildNews"
        case .guildStore:         return "GuildStore"
        case .guildNewsThread:    return "GuildNewsThread"
        case .guildPublicThread:  return "GuildPublicThread"
        case .guildPrivateThread: return "GuildPrivateThread"
        case .guildStageVoice:    return "GuildStageVoice"
        case .guildDirectory:     return "GuildDirectory"
        case .guildForum:         return "GuildForum"
        case .guildMedia:         return "GuildMedia"
        case .lobby:              return "Lobby"
        case .ephemeralDm:        return "EphemeralDm"
        }
    }
}

extension AudioSystem: CustomStringConvertible {
    public var description: String {
        switch self {
        case .standard: return "Standard"
        case .game:     return "Game"
        }
    }
}

extension AudioModeType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .uninitialized: return "MODE_UNINIT"
        case .vad:           return "MODE_VAD"
        case .ptt:           return "MODE_PTT"
        }
    }
}

extension RelationshipType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:            return "None"
        case .friend:          return "Friend"
        case .blocked:         return "Blocked"
        case .pendingIncoming: return "PendingIncoming"
        case .pendingOutgoing: return "PendingOutgoing"
        case .implicit:        return "Implicit"
        case .suggestion:      return "Suggestion"
        }
    }
}

extension ExternalIdentityProviderType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .oidc:               return "OIDC"
        case .epicOnlineServices: return "EpicOnlineServices"
        case .steam:              return "Steam"
        case .unity:              return "Unity"
        case .discordBot:         return "DiscordBot"
        case .none:               return "None"
        case .unknown:            return "Unknown"
        }
    }
}

extension StatusType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .online:    return "Online"
        case .offline:   return "Offline"
        case .blocked:   return "Blocked"
        case .idle:      return "Idle"
        case .dnd:       return "Dnd"
        case .invisible: return "Invisible"
        case .streaming: return "Streaming"
        case .unknown:   return "Unknown"
        }
    }
}

extension DisclosureType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .messageDataVisibleOnDiscord: return "MessageDataVisibleOnDiscord"
        }
    }
}

extension AuthorizationTokenType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .user:   return "User"
        case .bearer: return "Bearer"
        }
    }
}

extension AuthenticationExternalAuthType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .oidc:                         return "OIDC"
        case .epicOnlineServicesAccessToken: return "EpicOnlineServicesAccessToken"
        case .epicOnlineServicesIdToken:    return "EpicOnlineServicesIdToken"
        case .steamSessionTicket:           return "SteamSessionTicket"
        case .unityServicesIdToken:         return "UnityServicesIdToken"
        case .discordBotIssuedAccessToken:  return "DiscordBotIssuedAccessToken"
        case .appleIdToken:                 return "AppleIdToken"
        case .playStationNetworkIdToken:    return "PlayStationNetworkIdToken"
        }
    }
}

extension LoggingSeverity: CustomStringConvertible {
    public var description: String {
        switch self {
        case .verbose: return "Verbose"
        case .info:    return "Info"
        case .warning: return "Warning"
        case .error:   return "Error"
        case .none:    return "None"
        }
    }
}

//extension ClientResult: CustomStringConvertible {
//    public var description: String {
//        var raw = Discord_String(ptr: nil, size: 0)
//        Discord_ClientResult_ToString(&storage.raw, &raw)
//        return String(discordOwned: raw)
//    }
//}

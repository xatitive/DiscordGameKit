//
//  ClientConstants.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 4/5/26.
//

@_implementationOnly import discord_partner_sdk

public enum Discord {
    
    /// Runs pending callbacks from the Discord SDK.
    ///
    /// You should call this function periodically to process callbacks, e.g. once per frame.
    public static func runCallbacks() {
        Discord_RunCallbacks()
    }
    
    /// Returns the ID of the system default audio device if the user has not explicitly chosen one.
    public static let audioDeviceId: String = {
        var ds = Discord_String()
        Discord_Client_GetDefaultAudioDeviceId(&ds)
        return ds.toString()
    }()
    
    /// Returns the default set of OAuth2 scopes that should be used with the Discord SDK
    /// when making use of the full SDK capabilities, including communications-related features
    /// (e.g. user DMs, lobbies, voice chat). If your application does not make use of these
    /// features, you should use ``Discord/presenceScopes`` instead.
    ///
    /// Communications-related features are currently in limited access and are not available to
    /// all applications, however, they can be demoed in limited capacity by all applications. If
    /// you are interested in using these features in your game, please reach out to the Discord
    /// team.
    ///
    /// It's ok to further customize your requested OAuth2 scopes to add additional scopes if you
    /// have legitimate usages for them. However, we strongly recommend always using
    /// ``Discord/communicationScopes`` or ``Discord/presenceScopes`` as a baseline to
    /// enable a better authorization experience for users!
    public static let communicationScopes: String = {
        var ds = Discord_String()
        Discord_Client_GetDefaultCommunicationScopes(&ds)
        return ds.toString()
    }()
    
    /// Returns the default set of OAuth2 scopes that should be used with the Discord SDK
    /// when leveraging baseline presence-related features (e.g. friends list, rich presence,
    /// provisional accounts, activity invites). If your application is using
    /// communications-related features, which are currently available in limited access, you should
    /// use ``Discord/communicationScopes`` instead.
    ///
    /// It's ok to further customize your requested OAuth2 scopes to add additional scopes if you
    /// have legitimate usages for them. However, we strongly recommend always using
    /// ``Discord/communicationScopes`` or ``Discord/presenceScopes`` as a baseline to
    /// enable a better authorization experience for users!
    public static let presenceScopes: String = {
        var ds = Discord_String()
        Discord_Client_GetDefaultPresenceScopes(&ds)
        return ds.toString()
    }()
    
    /// Major version of the Discord Social SDK.
    public static let versionMajor: Int32 = {
        Discord_Client_GetVersionMajor()
    }()
    
    /// Minor version of the Discord Social SDK.
    public static let versionMinor: Int32 = {
        Discord_Client_GetVersionMinor()
    }()
    
    /// Patch version of the Discord Social SDK.
    public static let versionPatch: Int32 = {
        Discord_Client_GetVersionPatch()
    }()
    
    /// Git commit hash this version was built from.
    public static let versionHash: String = {
        var ds = Discord_String()
        Discord_Client_GetVersionHash(&ds)
        return ds.toString()
    }()
}

//private func getDefaults() -> DiscordClientConstants.Defaults {
//    var device = Discord_String()
//    Discord_Client_GetDefaultAudioDeviceId(&device)
//    
//    var communication = Discord_String()
//    Discord_Client_GetDefaultCommunicationScopes(&communication)
//    
//    var presence = Discord_String()
//    Discord_Client_GetDefaultPresenceScopes(&presence)
//    
//    return .init(
//        audioDeviceId: device.toString(),
//        communicationScopes: communication.toString(),
//        presenceScopes: presence.toString()
//    )
//}
//
//private func getVersion() -> DiscordClientConstants.Version {
//    var hash = Discord_String()
//    Discord_Client_GetVersionHash(&hash)
//    
//    return .init(
//        major: Discord_Client_GetVersionMajor(),
//        minor: Discord_Client_GetVersionMinor(),
//        patch: Discord_Client_GetVersionPatch(),
//        hash: hash.toString()
//    )
//}

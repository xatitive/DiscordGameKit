//
//  DeviceAuthorizationArgs.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Arguments to ``DiscordClient/getTokenFromDevice(args:_:)``
public struct DeviceAuthorizationArgs: DiscordObject, CustomStringConvertible {
    var storage: DiscordStorage<Discord_DeviceAuthorizationArgs>
    init(storage: DiscordStorage<Discord_DeviceAuthorizationArgs>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// Optional. The Discord application ID for your game. Defaults to the value set by ``DiscordClient/applicationId``
    public var clientId: UInt64 {
        get { usingLock { $0.clientId() } }
        set {
            ensureUnique()
            usingLock { $0.setClientId(newValue) }
        }
    }

    /// Scopes is a space separated string of the oauth scopes your game is requesting.
    ///
    /// Most games should just pass in ``Discord/communicationScopes`` or
    /// ``Discord/presenceScopes`` which will include these scopes, respectively:
    /// `openid sdk.social_layer` or `openid sdk.social_layer_presence`
    ///
    /// `sdk.social_layer` and `sdk.social_layer_presence` automatically expand to include all the
    /// necessary scopes for the integration.
    ///
    /// You can pass in additional scopes if you need to, but as a general rule you should only
    /// request the scopes you actually need, and the user will need to grant access to those
    /// additional scopes as well.
    public var scopes: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                raw.scopes(&ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock { $0.setScopes(str) }
            }
        }
    }

    public var description: String {
        "DeviceAuthorizationArgs(clientId: \(clientId), scopes: \(scopes))"
    }
}

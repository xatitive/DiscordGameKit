//
//  AuthorizationArgs.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Arguments to ``DiscordClient/authorize(args:_:)``
public struct AuthorizationArgs: DiscordObject, Sendable {
    var storage: DiscordStorage<Discord_AuthorizationArgs>
    init(storage: DiscordStorage<Discord_AuthorizationArgs>) {
        self.storage = storage
    }
    
    public init() {
        self.storage = .init()
    }
    
    /// Optional. The Discord application ID for your game. Defaults to the value set by ``DiscordClient/applicationId``
    public var clientId: UInt64 {
        get { usingLock(Discord_AuthorizationArgs_ClientId) }
        set {
            ensureUnique()
            usingLock(Discord_AuthorizationArgs_SetClientId, newValue)
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
                Discord_AuthorizationArgs_Scopes(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock(Discord_AuthorizationArgs_SetScopes, str)
            }
        }
    }
    
    /// See https://discord.com/developers/docs/topics/oauth2#state-and-security for details on this field.
    ///
    /// We recommend leaving this unset, and the SDK will automatically generate a secure random value for you.
    public var state: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                guard Discord_AuthorizationArgs_State(&raw, &ds) else { return nil }
                return String(discordOwned: ds)
            }
        }
        _modify {
            ensureUnique()
            var value = self.state
            yield &value
            guard let value else {
                usingLock(Discord_AuthorizationArgs_SetState, nil)
                return
            }
            value.withDiscordStringPointer { ptr in
                usingLock(Discord_AuthorizationArgs_SetState, ptr)
            }
        }
    }
    
    /// The nonce field is generally only useful for backend integrations using ID tokens.
    ///
    /// For more information, see:
    ///https://openid.net/specs/openid-connect-core-1_0.html#rfc.section.2~nonce:~:text=auth_time%20response%20parameter.)-,nonce,-String%20value%20used
    public var nonce: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                guard Discord_AuthorizationArgs_Nonce(&raw, &ds) else { return nil }
                return String(discordOwned: ds)
            }
        }
        _modify {
            ensureUnique()
            var value = self.nonce
            yield &value
            guard let value else {
                usingLock(Discord_AuthorizationArgs_SetNonce, nil)
                return
            }
            value.withDiscordStringPointer { ptr in
                usingLock(Discord_AuthorizationArgs_SetNonce, ptr)
            }
        }
    }
    
    /// If using the ``DiscordClient/getToken(application:code:codeVerifier:redirectUri:_:)`` flow, you will need to generate a code challenge and verifier.
    ///
    /// Use ``DiscordClient/authorizationCodeVerifier`` to generate these values and pass the challenge property here.
    public var codeChallenge: AuthorizationCodeChallenge? {
        get {
            var codeChallenge = Discord_AuthorizationCodeChallenge()
            guard storage.withLock({ Discord_AuthorizationArgs_CodeChallenge(&$0, &codeChallenge) }) else { return nil }
            return AuthorizationCodeChallenge(storage: .init(takingOwnership: codeChallenge))
        }
        _modify {
            ensureUnique()
            var value = self.codeChallenge
            yield &value
            
            guard let value else {
                usingLock(Discord_AuthorizationArgs_SetCodeChallenge, nil)
                return
            }
            
            value.storage.withLock { challenge in
                self.storage.withLock { raw in
                    Discord_AuthorizationArgs_SetCodeChallenge(&raw, &challenge)
                }
            }
        }
    }
    
    /// The type of integration the app will be installed as.
    ///
    /// - seealso: https://discord.com/developers/docs/resources/application#installation-context
    public var integrationType: IntegrationType? {
        get {
            var integrationType = Discord_IntegrationType_forceint
            guard storage.withLock({ Discord_AuthorizationArgs_IntegrationType(&$0, &integrationType) }) else { return nil }
            return integrationType.swiftValue
        }
        _modify {
            ensureUnique()
            var value = self.integrationType
            yield &value
            guard let value else {
                usingLock(Discord_AuthorizationArgs_SetIntegrationType, nil)
                return
            }
            storage.withLock { raw in
                var dValue = value.discordValue
                Discord_AuthorizationArgs_SetIntegrationType(&raw, &dValue)
            }
        }
    }
    
    /// Custom URI scheme for mobile redirects.
    ///
    /// This allows games to specify a completely custom URI scheme for OAuth redirects.
    /// For example, setting this to "mygame" will result in a URI scheme like:
    /// mygame:/authorize/callback
    ///
    /// If not provided, defaults to the standard Discord format:
    /// discord-123456789:/authorize/callback
    ///
    /// This is particularly useful for distinguishing between multiple games from the same
    /// developer or for avoiding conflicts with other apps.
    public var customSchemeParam: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                guard Discord_AuthorizationArgs_CustomSchemeParam(&raw, &ds) else { return nil }
                return String(discordOwned: ds)
            }
        }
        _modify {
            ensureUnique()
            var value = self.customSchemeParam
            yield &value
            guard let value else {
                usingLock(Discord_AuthorizationArgs_SetCustomSchemeParam, nil)
                return
            }
            value.withDiscordStringPointer { ptr in
                usingLock(Discord_AuthorizationArgs_SetCustomSchemeParam, ptr)
            }
        }
    }
}

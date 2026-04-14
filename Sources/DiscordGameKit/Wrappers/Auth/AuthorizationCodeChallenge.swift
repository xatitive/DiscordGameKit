//
//  AuthorizationCodeChallenge.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that encapsulates the challenge part of the code verification flow.
public struct AuthorizationCodeChallenge: DiscordObject, CustomStringConvertible {
    var storage: DiscordStorage<Discord_AuthorizationCodeChallenge>
    init(storage: DiscordStorage<Discord_AuthorizationCodeChallenge>) {
        self.storage = storage
    }
    
    public init() {
        self.storage = .init()
    }
    
    /// The method used to generate the challenge. The only method used by the SDK is `sha256`.
    public var method: AuthenticationCodeChallengeMethod {
        get { usingLock { $0.method().swiftValue } }
        set {
            ensureUnique()
            usingLock { $0.setMethod(newValue.discordValue) }
        }
    }
    
    /// The challenge value
    public var challenge: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                raw.challenge(&ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock { $0.setChallenge(str) }
            }
        }
    }

    public var description: String {
        "AuthorizationCodeChallenge(method: \(method), challenge: \(challenge))"
    }
}

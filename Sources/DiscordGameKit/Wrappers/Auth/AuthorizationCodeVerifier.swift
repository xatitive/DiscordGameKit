//
//  AuthorizationCodeVerifier.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that encapsulates both parts of the code verification flow.
public struct AuthorizationCodeVerifier: DiscordObject, Sendable {
    var storage: DiscordStorage<Discord_AuthorizationCodeVerifier>
    init(storage: DiscordStorage<Discord_AuthorizationCodeVerifier>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// The challenge part of the code verification flow.
    public var challenge: AuthorizationCodeChallenge {
        get {
        	storage.withLock { raw in
                var challenge = Discord_AuthorizationCodeChallenge()
                Discord_AuthorizationCodeVerifier_Challenge(&raw, &challenge)
                return AuthorizationCodeChallenge(takingOwnership: challenge)
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                newValue.storage.withLock { challenge in
                    Discord_AuthorizationCodeVerifier_SetChallenge(&raw, &challenge)
                }
            }
        }
    }

    /// The verifier part of the code verification flow.
    public var verifier: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_AuthorizationCodeVerifier_Verifier(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
				usingLock(Discord_AuthorizationCodeVerifier_SetVerifier, str)
            }
        }
    }
}

//
//  AuthorizationCodeVerifier.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that encapsulates both parts of the code verification flow.
public struct AuthorizationCodeVerifier: DiscordObject, Sendable, CustomStringConvertible {
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
                raw.challenge(&challenge)
                return AuthorizationCodeChallenge(takingOwnership: challenge)
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                newValue.storage.withLock { challenge in
                    raw.setChallenge(&challenge)
                }
            }
        }
    }

    /// The verifier part of the code verification flow.
    public var verifier: String {
        get {
            storage.withLock { raw in
                gettingString { span in
                    raw.verifier(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { buf in
                    raw.setVerifier(span: buf)
                }
            }
        }
    }

    public var description: String {
        "AuthorizationCodeVerifier(challenge: \(challenge), verifier: \(verifier))"
    }
}

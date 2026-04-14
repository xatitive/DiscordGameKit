//
//  AuthorizationCodeVerifier.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk
public import ViewConfigurable

/// Struct that encapsulates both parts of the code verification flow.
@ViewConfigurable
public struct AuthorizationCodeVerifier: DiscordObject, @unchecked Sendable,
    CustomStringConvertible
{
    var storage: DiscordStorage<Discord_AuthorizationCodeVerifier>
    init(storage: DiscordStorage<Discord_AuthorizationCodeVerifier>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    private var isApplyingViewConfig = false
    private var viewConfig = ViewConfiguration() {
        didSet {
            guard !isApplyingViewConfig else { return }
            applyViewConfigChanges()
        }
    }

    private struct ViewConfiguration: @unchecked Sendable {
        var challenge: AuthorizationCodeChallenge?
        var verifier: String?
    }

    private mutating func withViewConfigApplicationDisabled(
        _ body: (inout ViewConfiguration) -> Void
    ) {
        isApplyingViewConfig = true
        body(&viewConfig)
        isApplyingViewConfig = false
    }

    private mutating func applyViewConfigChanges() {
        if let challenge = viewConfig.challenge {
            self.challenge = challenge
        }
        if let verifier = viewConfig.verifier {
            self.verifier = verifier
        }

        withViewConfigApplicationDisabled { $0 = .init() }
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
                var ds = Discord_String()
                raw.verifier(&ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock { $0.setVerifier(str) }
            }
        }
    }

    public var description: String {
        "AuthorizationCodeVerifier(challenge: \(challenge), verifier: \(verifier))"
    }
}

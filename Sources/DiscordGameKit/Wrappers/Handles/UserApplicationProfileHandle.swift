//
//  UserApplicationProfileHandle.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk

/// A ``UserApplicationProfileHandle`` represents a profile from an external identity provider,
/// such as Steam or Epic Online Services.
///
/// Handle objects in the SDK hold a reference both to the underlying data, and to the SDK instance.
/// Changes to the underlying data will generally be available on existing handles objects without
/// having to re-create them. If the SDK instance is destroyed, but you still have a reference to a
/// handle object, note that it will return the default value for all method calls (ie an empty
/// string for methods that return a string).
public struct UserApplicationProfileHandle: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_UserApplicationProfileHandle>
    init(storage: DiscordStorage<Discord_UserApplicationProfileHandle>) {
        self.storage = storage
    }

    /// The user's in-game avatar hash.
    public var avatarHash: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_UserApplicationProfileHandle_AvatarHash(&raw, &ds)
            return String(discordOwned: ds)
        }
    }
    
	/// Metadata set by the developer.
    public var metadata: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_UserApplicationProfileHandle_Metadata(&raw, &ds)
            return String(discordOwned: ds)
        }
    }

    /// The user's external identity provider ID if it exists.
    public var providerId: String? {
        storage.withLock { raw in
            var ds = Discord_String()
            guard Discord_UserApplicationProfileHandle_ProviderId(&raw, &ds) else { return nil }
            return String(discordOwned: ds)
        }
    }

    /// The user's external identity provider issued user ID.
    public var providerIssuedUserId: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_UserApplicationProfileHandle_ProviderIssuedUserId(&raw, &ds)
            return String(discordOwned: ds)
        }
    }

    /// Type of the external identity provider.
    public var providerType: ExternalIdentityProviderType {
        storage.withLock { Discord_UserApplicationProfileHandle_ProviderType(&$0).swiftValue }
    }

    /// The user's in-game username.
    public var username: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_UserApplicationProfileHandle_Username(&raw, &ds)
            return String(discordOwned: ds)
        }
    }

    public var description: String {
        "UserApplicationProfileHandle(username: \(username), avatarHash: \(avatarHash), providerType: \(providerType), providerId: \(providerId, default: "N/A"), providerIssuedUserId: \(providerIssuedUserId), metadata: \(metadata))"
    }
}

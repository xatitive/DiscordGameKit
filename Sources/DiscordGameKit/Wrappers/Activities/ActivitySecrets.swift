//
//  ActivitySecrets.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

/// See ``Activity/secrets``
public struct ActivitySecrets: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_ActivitySecrets>
    init(storage: DiscordStorage<Discord_ActivitySecrets>) {
        self.storage = storage
    }
    
    public init() {
        self.storage = .init()
    }
    
    /// A secret string that is shared with users who are accepted into the party so the game knows how to join the user to the party.
    ///
    /// For example you might specify an internal game server ID or a Discord lobby ID or secret.
    /// If specified, must be a string between 2 and 128 characters.
    public var join: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                raw.join(&ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                storage.withLock { raw in
                    raw.setJoin(str)
                }
            }
        }
    }
    
    public var description: String {
        "ActivitySecrets(join: \(join))"
    }

}

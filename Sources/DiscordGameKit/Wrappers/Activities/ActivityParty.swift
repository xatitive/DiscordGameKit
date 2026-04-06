//
//  Activity.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

/// See ``Activity/party``
public struct ActivityParty: DiscordObject, Identifiable {
    var storage: DiscordStorage<Discord_ActivityParty>
    init(storage: DiscordStorage<Discord_ActivityParty>) {
        self.storage = storage
    }
    
    public init(){
        self.storage = .init()
    }
    
    /// Specifies the id of the party. "Party" is used colloquially to refer to a group of players in a shared context. This could be a lobby id, server id, team id, etc.
    ///
    /// All party members should specify a RichPresence update using
    /// the same party id so that the Discord client knows how to group them together. If specified,
    /// must be a string between 2 and 128 characters.
    public var id: String {
        get {
            var ds = Discord_String()
            storage.withLock { raw in
                Discord_ActivityParty_Id(&raw, &ds)
            }
            return String(discordOwned: ds)
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                storage.withLock { raw in
                    Discord_ActivityParty_SetId(&raw, str)
                }
            }
        }
    }
    
    /// The number of people currently in the party, must be at least 1.
    public var currentSize: Int32 {
        get { storage.withLock { raw in Discord_ActivityParty_CurrentSize(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityParty_SetCurrentSize(&raw, newValue)
            }
        }
    }
    
    /// The maximum number of people that can be in the party, must be at least 0. When 0, the UI will not display a maximum.
    public var maxSize: Int32 {
        get { storage.withLock { raw in Discord_ActivityParty_MaxSize(&raw) } }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityParty_SetMaxSize(&raw, newValue)
            }
        }
    }
    
    /// The privacy of the party.
    public var privacy: ActivityPartyPrivacy {
        get {
            storage.withLock { raw in
                let privacy = Discord_ActivityParty_Privacy(&raw)
                return ActivityPartyPrivacy(rawValue: Int32(privacy.rawValue)) ?? .private
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_ActivityParty_SetPrivacy(&raw, newValue.discordValue)
            }
        }
    }
}

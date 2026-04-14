//
//  Activity.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk
public import ViewConfigurable

/// See ``Activity/party``
@ViewConfigurable
public struct ActivityParty: DiscordObject, Identifiable, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_ActivityParty>
    init(storage: DiscordStorage<Discord_ActivityParty>) {
        self.storage = storage
    }
    
    public init(){
        self.storage = .init()
    }

    private var isApplyingViewConfig = false
    private var viewConfig = ViewConfiguration() {
        didSet {
            guard !isApplyingViewConfig else { return }
            applyViewConfigChanges()
        }
    }

    private struct ViewConfiguration {
        var id: String?
        var currentSize: Int32?
        var maxSize: Int32?
        var privacy: ActivityPartyPrivacy?
    }

    private mutating func withViewConfigApplicationDisabled(
        _ body: (inout ViewConfiguration) -> Void
    ) {
        isApplyingViewConfig = true
        body(&viewConfig)
        isApplyingViewConfig = false
    }

    private mutating func applyViewConfigChanges() {
        if let id = viewConfig.id {
            self.id = id
        }
        if let currentSize = viewConfig.currentSize {
            self.currentSize = currentSize
        }
        if let maxSize = viewConfig.maxSize {
            self.maxSize = maxSize
        }
        if let privacy = viewConfig.privacy {
            self.privacy = privacy
        }

        withViewConfigApplicationDisabled { $0 = .init() }
    }
    
    /// Specifies the id of the party. "Party" is used colloquially to refer to a group of players in a shared context. This could be a lobby id, server id, team id, etc.
    ///
    /// All party members should specify a RichPresence update using
    /// the same party id so that the Discord client knows how to group them together. If specified,
    /// must be a string between 2 and 128 characters.
    public var id: String {
        get {
            storage.withLock { raw in
                gettingString { span in
                    raw.id(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { span in
                    raw.setId(span: span)
                }
            }
        }
    }
    
    /// The number of people currently in the party, must be at least 1.
    public var currentSize: Int32 {
        get { storage.withLock { raw in raw.currentSize() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setCurrentSize(newValue)
            }
        }
    }
    
    /// The maximum number of people that can be in the party, must be at least 0. When 0, the UI will not display a maximum.
    public var maxSize: Int32 {
        get { storage.withLock { raw in raw.maxSize() } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setMaxSize(newValue)
            }
        }
    }
    
    /// The privacy of the party.
    public var privacy: ActivityPartyPrivacy {
        get { storage.withLock { $0.privacy().swiftValue } }
        set {
            ensureUnique()
            storage.withLock { raw in
                raw.setPrivacy(newValue.discordValue)
            }
        }
    }
    
    public var description: String {
        "ActivityParty(id: \(id), currentSize: \(currentSize), maxSize: \(maxSize), privacy: \(privacy))"
    }
}

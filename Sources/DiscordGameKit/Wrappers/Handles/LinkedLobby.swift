//
//  LinkedLobby.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/31/26.
//

@_implementationOnly import discord_partner_sdk
public import ViewConfigurable

/// Struct that stores information about the lobby linked to a channel.
@ViewConfigurable
public struct LinkedLobby: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_LinkedLobby>
    init(storage: DiscordStorage<Discord_LinkedLobby>) {
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

    private struct ViewConfiguration {
        var applicationId: UInt64?
        var lobbyId: UInt64?
    }

    private mutating func withViewConfigApplicationDisabled(
        _ body: (inout ViewConfiguration) -> Void
    ) {
        isApplyingViewConfig = true
        body(&viewConfig)
        isApplyingViewConfig = false
    }

    private mutating func applyViewConfigChanges() {
        if let applicationId = viewConfig.applicationId {
            self.applicationId = applicationId
        }
        if let lobbyId = viewConfig.lobbyId {
            self.lobbyId = lobbyId
        }

        withViewConfigApplicationDisabled { $0 = .init() }
    }

    /// The ID of the application that owns the lobby.
    public var applicationId: UInt64 {
        get { usingLock { $0.applicationId() } }
        set {
            ensureUnique()
            usingLock { $0.setApplicationId(newValue) }
        }
    }

    /// ID of the lobby.
    public var lobbyId: UInt64 {
        get { usingLock { $0.lobbyId() } }
        set {
            ensureUnique()
            usingLock { $0.setLobbyId(newValue) }
        }
    }

    public var description: String {
        "LinkedLobby(applicationId: \(applicationId), lobbyId: \(lobbyId))"
    }
}

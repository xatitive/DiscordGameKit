//
//  VADThresholdSettings.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

/// Settings for the void auto detection threshold for picking up activity from a user's mic.
public struct VADThresholdSettings: DiscordObject {
    var storage: DiscordStorage<Discord_VADThresholdSettings>
    init(storage: DiscordStorage<Discord_VADThresholdSettings>) {
        self.storage = storage
    }
    
    public init() {
        self.storage = .init()
    }
    
    /// Whether or not Discord is currently automatically setting and detecting the appropriate threshold to use.
    public var automatic: Bool {
        get { usingLock { $0.automatic() } }
        set { usingLock { $0.setAutomatic(newValue) } }
    }
    
    /// The current void auto detection threshold value, has a range of -100, 0 and defaults to -60.
    public var threshold: Float {
        get { usingLock { $0.vadThreshold() } }
        set { usingLock { $0.setVadThreshold(newValue) } }
    }
    
    public var description: String {
        "VADThreshold(automatic: \(automatic), threshold: \(threshold))"
    }
}

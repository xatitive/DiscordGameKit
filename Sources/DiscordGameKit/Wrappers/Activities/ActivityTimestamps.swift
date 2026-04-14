//
//  ActivityTimestamps.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk
public import Foundation

/// See ``Activity/timestamps``
public struct ActivityTimestamps: DiscordObject, Sendable, CustomStringConvertible {
    var storage: DiscordStorage<Discord_ActivityTimestamps>
    init(storage: DiscordStorage<Discord_ActivityTimestamps>) {
        self.storage = storage
    }
    
    public init() {
        self.storage = .init()
    }
    
    /// The time the activity started, in milliseconds since Unix epoch.
    ///
    /// The SDK will try to convert seconds to milliseconds if a small-ish value is passed in.
    /// If specified, the Discord client will render a count up timer showing how long the user has
    /// been playing this activity.
    public var start: Date? {
        get {
            storage.withLock { raw in
                let time = TimeInterval(raw.start())
                guard time > 0 else { return nil }
                return Date(timeIntervalSince1970: time / 1000)
            }
        }
        set {
            ensureUnique()
            if let newValue {
                let time = UInt64(newValue.timeIntervalSince1970 * 1000)
                storage.withLock { raw in
                    raw.setStart(time)
                }
            } else {
                storage.withLock { raw in
                    raw.setStart(0)
                }
            }
        }
    }

    /// The time the activity will end at, in milliseconds since Unix epoch.
    ///
    /// The SDK will try to convert seconds to milliseconds if a small-ish value is passed in.
    /// If specified, the Discord client will render a countdown timer showing how long until the
    /// activity ends.
    public var end: Date? {
        get {
            storage.withLock { raw in
                let time = TimeInterval(raw.end())
                guard time > 0 else { return nil }
                return Date(timeIntervalSince1970: time / 1000)
            }
        }
        set {
            ensureUnique()
            if let newValue {
                let time = UInt64(newValue.timeIntervalSince1970 * 1000)
                storage.withLock { raw in
                    raw.setEnd(time)
                }
            } else {
                storage.withLock { raw in
                    raw.setEnd(0)
                }
            }
        }
    }
    
    public var description: String {
        "ActivityTimestamps(start: \(start, default: "N/A"), end: \(end, default: "N/A"))"
    }
}

//
//  ActivityButton.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

/// See ``Activity``
public struct ActivityButton: DiscordObject, CustomStringConvertible {
    var storage: DiscordStorage<Discord_ActivityButton>
    init(storage: DiscordStorage<Discord_ActivityButton>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// The label of the button.
    public var label: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                raw.label(&ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                newValue.withDiscordString { str in
                    raw.setLabel(str)
                }
            }
        }
    }

    /// The url of the button.
    public var url: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                raw.url(&ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                newValue.withDiscordString { str in
                    raw.setUrl(str)
                }
            }
        }
    }

    public var description: String {
        "ActivityButton(label: \(label), url: \(url))"
    }
}

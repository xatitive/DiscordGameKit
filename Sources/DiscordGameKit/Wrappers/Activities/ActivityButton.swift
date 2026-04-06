//
//  ActivityButton.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

/// See ``Activity``
public struct ActivityButton: DiscordObject {
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
            storage.withLock {
                var ds = Discord_String()
                Discord_ActivityButton_Label(&$0, &ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                newValue.withDiscordString { str in
                    Discord_ActivityButton_SetLabel(&raw, str)
                }
            }
        }
    }

    /// The url of the button.
    public var url: String {
        get {
            storage.withLock {
                var ds = Discord_String()
                Discord_ActivityButton_Url(&$0, &ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                newValue.withDiscordString { str in
                    Discord_ActivityButton_SetUrl(&raw, str)
                }
            }
        }
    }
}

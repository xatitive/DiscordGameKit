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
                gettingString { span in
                    raw.label(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { span in
                    raw.setLabel(span: span)
                }
            }
        }
    }

    /// The url of the button.
    public var url: String {
        get {
            storage.withLock { raw in
                gettingString { span in
                    raw.url(span: &span)
                }
            }
        }
        set {
            ensureUnique()
            storage.withLock { raw in
                settingString(newValue) { span in
                    raw.setUrl(span: span)
                }
            }
        }
    }

    public var description: String {
        "ActivityButton(label: \(label), url: \(url))"
    }
}

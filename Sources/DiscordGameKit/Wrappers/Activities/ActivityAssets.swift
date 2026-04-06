//
//  ActivityAssets.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct which controls what your rich presence looks like in the Discord client. If you don't specify any values, the icon and name of your application will be used as defaults.
///
/// Image assets can be either the unique identifier for an image
/// you uploaded to your application via the `Rich Presence` page in
/// the Developer portal, or they can be an external image URL.
///
/// As an example, if I uploaded an asset and name it `goofy-icon`,
/// I could set either image field to the string `goofy-icon`. Alternatively,
/// if my icon was hosted at `http://my-site.com/goofy.jpg`, I could
/// pass that URL into either image field.
///
/// See https://discord.com/developers/docs/rich-presence/overview#adding-custom-art-assets
/// for more information on using custom art assets, as well as for visual
/// examples of what each field does.
public struct ActivityAssets: DiscordObject {
    var storage: DiscordStorage<Discord_ActivityAssets>
    init(storage: DiscordStorage<Discord_ActivityAssets>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }

    /// The primary image identifier or URL, rendered as a large square icon on a user's rich presence.
    ///
    /// If specified, must be a string between 1 and 300 characters.
    public var largeImage: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                return Discord_ActivityAssets_LargeImage(&raw, &ds) ? String(discordOwned: ds) : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.largeImage
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetLargeImage(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { ptr in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetLargeImage(&raw, ptr)
                }
            }
        }
    }
	
    /// A tooltip string that is shown when the user hovers over the large image.
    ///
    /// If specified, must be a string between 2 and 128 characters.
    public var largeText: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                return Discord_ActivityAssets_LargeText(&raw, &ds) ? String(discordOwned: ds) : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.largeImage
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetLargeText(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { ptr in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetLargeText(&raw, ptr)
                }
            }
        }
    }

	/// A URL that opens when the user clicks/taps the large image.
    ///
    /// If specified, must be a string between 1 and 256 characters.
    public var largeUrl: String? {
        get {
            var ds = Discord_String()
            guard storage.withLock({ raw in
                Discord_ActivityAssets_LargeUrl(&raw, &ds)
            }) else {
                return nil
            }
            return String(discordOwned: ds)
        }
        _modify {
            ensureUnique()
            var value = self.largeUrl
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetLargeUrl(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetLargeUrl(&raw, str)
                }
            }
        }
    }

    /// The secondary image, rendered as a small circle over the ``largeImage``.
    ///
    /// If specified, must be a string between 1 and 300 characters.
    public var smallImage: String? {
        get {
            var ds = Discord_String()
            guard storage.withLock({ raw in
                Discord_ActivityAssets_SmallImage(&raw, &ds)
            }) else {
                return nil
            }
            return String(discordOwned: ds)
        }
        _modify {
            ensureUnique()
            var value = self.smallImage
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetSmallImage(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetSmallImage(&raw, str)
                }
            }
        }
    }

    /// A tooltip string that is shown when the user hovers over the small image.
    ///
    /// If specified, must be a string between 2 and 128 characters.
    public var smallText: String? {
        get {
            var ds = Discord_String()
            guard storage.withLock({ raw in
                Discord_ActivityAssets_SmallText(&raw, &ds)
            }) else {
                return nil
            }
            return String(discordOwned: ds)
        }
        _modify {
            ensureUnique()
            var value = self.smallText
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetSmallText(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetSmallText(&raw, str)
                }
            }
        }
    }

    /// A URL that opens when the user clicks/taps the small image.
    ///
    /// If specified, must be a string between 1 and 256 characters.
    public var smallUrl: String? {
        get {
            var ds = Discord_String()
            guard storage.withLock({ raw in
                Discord_ActivityAssets_SmallUrl(&raw, &ds)
            }) else {
                return nil
            }
            return String(discordOwned: ds)
        }
        _modify {
            ensureUnique()
            var value = self.smallUrl
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetSmallUrl(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetSmallUrl(&raw, str)
                }
            }
        }
    }

    /// The invite cover image identifier or URL, rendered as a banner image on activity invites.
    ///
    /// If specified, must be a string between 1 and 300 characters.
    public var inviteCoverImage: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                return Discord_ActivityAssets_InviteCoverImage(&raw, &ds) ? String(discordOwned: ds) : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.inviteCoverImage
            yield &value
            guard let value else {
                storage.withLock { raw in
                    Discord_ActivityAssets_SetInviteCoverImage(&raw, nil)
                }
                return
            }
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_ActivityAssets_SetInviteCoverImage(&raw, str)
                }
            }
        }
    }
}

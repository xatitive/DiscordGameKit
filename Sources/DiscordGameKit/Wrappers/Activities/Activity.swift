//
//  Activity.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

// TODO: fix optional value setting

/// An Activity represents one "thing" a user is doing on Discord and is part of their rich
/// presence.
///
/// Additional information is located on the Discord Developer Portal:
/// - https://discord.com/developers/docs/rich-presence/overview
/// - https://discord.com/developers/docs/developer-tools/game-sdk#activities
/// - https://discord.com/developers/docs/rich-presence/best-practices
///
/// While RichPresence supports multiple types of activities, the only activity type that is really
/// relevant for the SDK is ActivityTypes::Playing. Additionally, the SDK will only expose
/// Activities that are associated with the current game (or application). So for example, a field
/// like `name` below, will always be set to the current game's name from the view of the SDK.
///
/// ## Customization
/// When an activity shows up on Discord, it will look something like this:
/// 1. Playing "game name"
/// 2. Capture the flag | 2 - 1
/// 3. In a group (2 of 3)
///
/// You can control how lines 2 and 3 are rendered in Discord, here's the breakdown:
/// - Line 1, `Playing "game name"` is powered by the name of your game (or application) on Discord.
/// - Line 2, `Capture the flag | 2 - 1` is powered by the `details` field in the activity, and this
/// should generally try to describe what the _player_ is currently doing. You can even include
/// dynamic data such as a match score here.
/// - Line 3, `In a group (2 of 3)` describes the _party_ the player is in. "Party" is used to refer
/// to a group of players in a shared context, such as a lobby, server, team, etc. The first half,
/// `In a group` is powered by the `state` field in the activity, and the second half, `(2 of 3)` is
/// powered by the `party` field in the activity and describes how many people are in the current
/// party and how big the party can get.
///
/// This diagram visually shows the field mapping:
///
///
/// \image html "rich_presence.png" "Rich presence field diagram" width=1070px
///
/// You can also specify up to two custom buttons to display on the rich presence.
/// These buttons will open the URL in the user's default browser.
///
/// \code
///     discordpp::ActivityButton button;
///     button.SetLabel("Button 1");
///     button.SetUrl("https://example.com");
///     activity.AddButton(button);
/// \endcode
///
///
/// ## Invites / Joinable Activities
/// Other users can be invited to join the current player's activity (or request to join it too),
/// but that does require certain fields to be set:
/// 1. ActivityParty must be set and have a non-empty ActivityParty::Id field. All users in the
/// party should set the same id field too!
/// 2. ActivityParty must specify the size of the group, and there must be room in the group for
/// another person to join.
/// 3. ActivitySecrets::Join must be set to a non-empty string. The join secret is only shared with
/// users who are accepted into the party by an existing member, so it is truly a secret. You can
/// use this so that when the user is accepted your game knows how to join them to the party. For
/// example it could be an internal game ID, or a Discord lobby ID/secret that the client could
/// join.
///
/// There is additional information about game invites here:
/// https://support.discord.com/hc/en-us/articles/115001557452-Game-Invites
///
/// ### Mobile Invites
/// Activity invites are handled via a deep link. To enable users to join your game via an invite in
/// the Discord client, you must do two things:
/// 1. Set your deep link URL in the Discord developer portal. This will be available on the General
/// tab of your application once Social Layer integration is enabled for your app.
/// 2. Set the desired supported platforms when reporting the activity info in your rich presence,
/// e.g.:
///
///
/// \code
///     activity.SetSupportedPlatforms(
///         ActivityGamePlatforms.Desktop |
///         ActivityGamePlatforms.IOS |
///         ActivityGamePlatforms.Android);
/// \endcode
///
///
/// When the user accepts the invite, the Discord client will open:
/// `[your url]/_discord/join?secret=[the join secret you set]`
///
/// ### Example Invites Flow
/// If you are using Discord lobbies for your game, a neat flow would look like this:
/// - When a user starts playing the game, they create a lobby with a random secret string, using
/// Client::CreateOrJoinLobby
/// - That user publishes their RichPresence with the join secret set to the lobby secret, along
/// with party size information
/// - Another use can then see that RichPresence on Discord and join off of it
/// - Once accepted the new user receives the join secret and their client can call
/// CreateOrJoinLobby(joinSecret) to join the lobby
/// - Finally the original user can notice that the lobby membership has changed and so they publish
/// a new RichPresence update containing the updating party size information.
///
/// ### Invites Code Example
///
/// \code
/// // User A
/// // 1. Create a lobby with secret
/// std::string lobbySecret = "foo";
/// client->CreateOrJoinLobby(lobbySecret, [=](discordpp::ClientResult result, uint64_t lobbyId) {
///     // 2. Update rich presence with join secret
///     discordpp::Activity activity{};
///     // set name, state, party size ...
///     discordpp::ActivitySecrets secrets{};
///     secrets.SetJoin(lobbySecret);
///     activity.SetSecrets(secrets);
///     client->UpdateRichPresence(std::move(activity), [](discordpp::ClientResult result) {});
/// });
/// // 3. Some time later, send an invite
/// client->SendActivityInvite(USER_B_ID, "come play with me", [](auto result) {});
///
/// // User B
/// // 4. Monitor for new invites. Alternatively, you can use
/// // Client::SetActivityInviteUpdatedCallback to get updates on existing invites.
/// client->SetActivityInviteCreatedCallback([client](auto invite) {
///     // 5. When an invite is received, ask the user if they want to accept it.
///     // If they choose to do so then go ahead and invoke AcceptActivityInvite
///     client->AcceptActivityInvite(invite,
///         [client](discordpp::ClientResult result, std::string secret) {
///         if (result.Successful()) {
///             // 5. Join the lobby using the joinSecret
///             client->CreateOrJoinLobby(secret, [](discordpp::ClientResult result, uint64_t
///             lobbyId) {
///                 // Successfully joined lobby!
///             });
///         }
///     });
/// });
/// \endcode
///
///
/// ### Join Requests Code Example
/// Users can also request to join each others parties. This code snippet shows how that flow might
/// look:
///
/// \code
/// // User A
/// // 1. Create a lobby with secret
/// std::string lobbySecret = "foo";
/// client->CreateOrJoinLobby(lobbySecret, [=](discordpp::ClientResult result, uint64_t lobbyId) {
///     // 2. Update rich presence with join secret
///     discordpp::Activity activity{};
///     // set name, state, party size ...
///     discordpp::ActivitySecrets secrets{};
///     secrets.SetJoin(lobbySecret);
///     activity.SetSecrets(secrets);
///     client->UpdateRichPresence(std::move(activity), [](discordpp::ClientResult result) {});
/// });
///
/// // User B
/// // 3. Request to join User A's party
/// client->SendActivityJoinRequest(USER_A_ID, [](auto result) {});
///
/// // User A
/// // Monitor for new invites:
/// client->SetActivityInviteCreatedCallback([client](auto invite) {
///     // 5. The game can now show that User A has received a request to join their party
///     // If User A is ok with that, they can reply back:
///     // Note: invite.type will be ActivityActionTypes::JoinRequest in this example
///     client->SendActivityJoinRequestReply(invite, [](auto result) {});
/// });
///
/// // User B
/// // 6. Same as before, user B can monitor for invites
/// client->SetActivityInviteCreatedCallback([client](auto invite) {
///     // 7. When an invite is received, ask the user if they want to accept it.
///     // If they choose to do so then go ahead and invoke AcceptActivityInvite
///     client->AcceptActivityInvite(invite,
///         [client](discordpp::ClientResult result, std::string secret) {
///         if (result.Successful()) {
///             // 5. Join the lobby using the joinSecret
///             client->CreateOrJoinLobby(secret, [](auto result, uint64_t lobbyId) {
///                 // Successfully joined lobby!
///             });
///         }
///     });
/// });
/// \endcode
///
public struct Activity: DiscordObject, CustomStringConvertible {
    var storage: DiscordStorage<Discord_Activity>
    init(storage: DiscordStorage<Discord_Activity>) {
        self.storage = storage
    }

    public init() {
        self.storage = .init()
    }
    
	/// The name of the game or application that the activity is associated with.
    ///
    /// This field defaults to the name of the current game.
    public var name: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_Activity_Name(&raw, &ds)
                return ds.toString()
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                storage.withLock { raw in
                    Discord_Activity_SetName(&raw, str)
                }
            }
        }
    }

    /// The type of activity this is.
    ///
    /// This should almost always be set to ``ActivityType/playing``
    public var type: ActivityType {
        get { usingLock(Discord_Activity_Type).swiftValue }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_Activity_SetType(&raw, newValue.discordValue)
            }
        }
    }

    /// If an activity is joinable, but only on certain platforms, this field can be used to indicate which platforms the activity is joinable on.
    ///
    /// For example if a game is available on both PC and Mobile, but PC users cannot join Mobile users and vice versa, this field can be
    /// used so that an activity only shows as joinable on Discord if the user is on the appropriate platform.
    public var supportedPlatform: ActivityGamePlatform {
        get { usingLock(Discord_Activity_SupportedPlatforms).swiftValue }
        set {
            ensureUnique()
            storage.withLock { raw in
                Discord_Activity_SetSupportedPlatforms(
                    &raw,
                    newValue.discordValue
                )
            }
        }
    }

    /// Controls which field is used for the user's status message
    ///
    /// See the docs on the struct for more info.
    public var statusDisplay: StatusDisplayType? {
        get {
            storage.withLock { raw in
                var v = Discord_StatusDisplayTypes_forceint
                return Discord_Activity_StatusDisplayType(&raw, &v) ? v.swiftValue : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.statusDisplay
            yield &value
            
            guard var value else {
                usingLock(Discord_Activity_SetStatusDisplayType, nil)
                return
            }
            
            storage.withLock { raw in
                Discord_Activity_SetStatusDisplayType(&raw, &value.discordValue)
            }
        }
    }

    /// The state _of the party_ for this activity.
    ///
    /// See the docs on the Activity struct for more info.
    /// If specified, must be a string between 2 and 128 characters.
    public var state: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                return Discord_Activity_State(&raw, &ds) ? ds.toString() : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.state
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetState, nil)
                return
            }
            
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_Activity_SetState(&raw, str)
                }
            }
        }
    }

    /// A URL that opens when the user clicks/taps the state text.
    ///
    /// See the docs on the Activity struct for more info.
    /// If specified, must be a string between 2 and 256 characters.
    public var stateUrl: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                return Discord_Activity_StateUrl(&raw, &ds) ? ds.toString() : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.state
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetStateUrl, nil)
                return
            }
            
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_Activity_SetStateUrl(&raw, str)
                }
            }
        }
    }

    /// The state _of the what the user is doing_ for this activity.
    ///
    /// See the docs on the Activity struct for more info.
    /// If specified, must be a string between 2 and 128 characters.
    public var details: String? {
        get {
            storage.withLock { raw in
            	var ds = Discord_String()
                return Discord_Activity_Details(&raw, &ds) ? ds.toString() : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.state
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetDetails, nil)
                return
            }
            
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_Activity_SetDetails(&raw, str)
                }
            }
        }
    }

    /// A URL that opens when the user clicks/taps the details text.
    ///
    /// See the docs on the Activity struct for more info.
    /// If specified, must be a string between 2 and 256 characters.
    public var detailsUrl: String? {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                return Discord_Activity_DetailsUrl(&raw, &ds) ? ds.toString() : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.state
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetDetailsUrl, nil)
                return
            }
            
            value.withDiscordStringPointer { str in
                storage.withLock { raw in
                    Discord_Activity_SetDetailsUrl(&raw, str)
                }
            }
        }
    }

    /// The application ID of the game that the activity is associated with.
    ///
    /// This field cannot be set by the SDK, and will always be the application ID of the current game or a game from the same publisher.
    public var applicationId: UInt64? {
        get {
            storage.withLock { raw in
                var v: UInt64 = 0
                return Discord_Activity_ApplicationId(&raw, &v) ? v : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.applicationId
            yield &value
            
            guard var value else {
                usingLock(Discord_Activity_SetApplicationId, nil)
                return
            }
            
            storage.withLock { raw in
                Discord_Activity_SetApplicationId(&raw, &value)
            }
        }
    }

    /// The application ID of the parent application that the activity is associated with if it exists. This is to help identify a collection of games that are from the same publisher.
    ///
    /// This field cannot be set by the SDK, and will always be the application ID of the game's parent or unset if the game has no parent.
    public var parentApplicationId: UInt64? {
        get {
            storage.withLock { raw in
                var v: UInt64 = 0
                return Discord_Activity_ParentApplicationId(&raw, &v) ? v : nil
            }
        }
        _modify {
            ensureUnique()
            var value = self.applicationId
            yield &value
            
            guard var value else {
                usingLock(Discord_Activity_SetParentApplicationId, nil)
                return
            }
            
            storage.withLock { raw in
                Discord_Activity_SetParentApplicationId(&raw, &value)
            }
        }
    }

    /// Images used to customize how the Activity is displayed in the Discord client.
    public var assets: ActivityAssets? {
        get {
            storage.withLock { activityRaw in 
                var raw = Discord_ActivityAssets()
                return Discord_Activity_Assets(&activityRaw, &raw) ? ActivityAssets(takingOwnership: raw) : ActivityAssets()
            }
        }
        _modify {
            ensureUnique()
            var value = self.assets
            yield &value
            
            guard let value else {
				usingLock(Discord_Activity_SetAssets, nil)
                return
            }
            
            storage.withLock { activityRaw in
                value.storage.withLock { assetRaw in
                    Discord_Activity_SetAssets(&activityRaw, &assetRaw)
                }
            }
        }
    }
    /// The timestamps struct can be used to render either:
    ///
    /// - a "time remaining" countdown timer (by specifying the ``ActivityTimestamps/end`` value)
    /// - a "time elapsed" countup timer (by specifying the ``ActivityTimestamps/start`` value)
    public var timestamps: ActivityTimestamps? {
        get {
            storage.withLock { activityRaw in
                var raw = Discord_ActivityTimestamps()
                return Discord_Activity_Timestamps(&activityRaw, &raw) ? ActivityTimestamps(takingOwnership: raw) : ActivityTimestamps()
            }
        }
        _modify {
            ensureUnique()
            var value = self.timestamps
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetTimestamps, nil)
                return
            }
            
            storage.withLock { activityRaw in
                value.storage.withLock { timestampRaw in
                    Discord_Activity_SetTimestamps(&activityRaw, &timestampRaw)
                }
            }
        }
    }

    /// The party struct is used to indicate the size and members of the people the current user is playing with.
    public var party: ActivityParty? {
        get {
            storage.withLock { activityRaw in
                var raw = Discord_ActivityParty()
                return Discord_Activity_Party(&activityRaw, &raw) ? ActivityParty(takingOwnership: raw) : ActivityParty()
            }
        }
        _modify {
            ensureUnique()
            var value = self.party
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetParty, nil)
                return
            }
            
            storage.withLock { activityRaw in
                value.storage.withLock { partyRaw in
                    Discord_Activity_SetParty(&activityRaw, &partyRaw)
                }
            }
        }
    }
    
    /// The secrets struct is used in combination with the party struct to make an Activity joinable.
    public var secrets: ActivitySecrets? {
        get {
            storage.withLock { activityRaw in
                var raw = Discord_ActivitySecrets()
                return Discord_Activity_Secrets(&activityRaw, &raw) ? ActivitySecrets(takingOwnership: raw) : ActivitySecrets()
            }
        }
        _modify {
            ensureUnique()
            var value = self.secrets
            yield &value
            
            guard let value else {
                usingLock(Discord_Activity_SetSecrets, nil)
                return
            }
            
            storage.withLock { raw in
                value.storage.withLock { val in
                    Discord_Activity_SetSecrets(&raw, &val)
                }
            }
        }
    }

    /// Adds a custom button to the rich presence
    public mutating func addButton(_ button: ActivityButton) {
        ensureUnique()
        storage.withLock { activityRaw in
            button.storage.withLock { buttonRaw in
                Discord_Activity_AddButton(&activityRaw, &buttonRaw)
            }
        }
    }

    /// Returns the custom buttons for the rich presence
    public var buttons: [ActivityButton] {
        storage.withLock { raw in
            var span = Discord_ActivityButtonSpan()
            Discord_Activity_GetButtons(&raw, &span)
            return span.converting()
        }
    }

    public var description: String {
        "Activity(name: \(name), type: \(type), supportedPlatform: \(supportedPlatform), statusDisplay: \(statusDisplay, default: "N/A"), state: \(state, default: "N/A"), stateUrl: \(stateUrl, default: "N/A"), details: \(details, default: "N/A"), detailsUrl: \(detailsUrl, default: "N/A"), applicationId: \(applicationId, default: "N/A"), parentApplicationId: \(parentApplicationId, default: "N/A"), assets: \(assets, default: "N/A"), timestamps: \(timestamps, default: "N/A"), party: \(party, default: "N/A"), secrets: \(secrets, default: "N/A"), buttons: \(buttons))"
    }
}

extension Activity: Equatable {
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        compare(lhs.storage, to: rhs.storage, Discord_Activity_Equals)
    }
}

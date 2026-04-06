//
//  CallbackDefs.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

import Foundation
@_implementationOnly import discord_partner_sdk

// TODO: Fix SetActivityCallback?

// =========================
// MARK: Generic Callbacks
// =========================
// Commonly reused callbacks within the SDK

public extension DiscordClient {
    typealias ClientResultCallback = @Sendable (_ result: Result<Void, ClientResult>) -> Void
    typealias VoidCallback = @Sendable () -> Void
    
    typealias EndCallCallback = VoidCallback
    typealias EndCallsCallback = VoidCallback
    
    typealias CurrentAudioDeviceCallback = @Sendable (AudioDevice) -> Void
    typealias AudioDevicesCallback = @Sendable ([AudioDevice]) -> Void
    
    typealias MessagesCallback = @Sendable (_ result: Result<[MessageHandle], ClientResult>) -> Void
    
    typealias UserIdentifierCallback = @Sendable (_ userId: UInt64) -> Void
    typealias MessageIdentifierCallback = @Sendable (_ messageID: UInt64) -> Void
    typealias LobbyIdentifierCallback = @Sendable (_ lobbyID: UInt64) -> Void
    typealias LobbyMemberCallback = @Sendable (_ lobbyID: UInt64, _ memberID: UInt64) -> Void
    typealias RelationshipCallback = @Sendable (_ userID: UInt64, _ isDiscordRelationshipUpdate: Bool) -> Void
}

// ===============================
// MARK: Important/Misc Callbacks
// ===============================

public extension DiscordClient {
    
    // MARK: Important
    /// Callback function invoked when a new log message is generated.
    typealias LogCallback = @Sendable (
        _ message: String,
        _ severity: LoggingSeverity
    ) -> Void
    
    /// Callback function for ``onStatusChanged(_:)``.
    //// `errorDetail` will usually be one of the error code described here:
    //// https://discord.com/developers/docs/topics/opcodes-and-status-codes#gateway-gateway-close-event-codes
    typealias StatusChangedCallback = @Sendable (_ result: Result<ClientStatus, ClientError>, ) -> Void
    
    /// Callback function for when ``updateRichPresence(to:_:)`` completes.
    typealias UpdateRichPresenceCallback = ClientResultCallback

    // MARK: Misc.
    /// Callback function for ``onUserUpdated(_:)``.
    typealias UserUpdatedCallback = UserIdentifierCallback
    
    /// Callback function for when ``setOnlineStatus(to:_:)`` completes.
    typealias UpdateStatusCallback = ClientResultCallback
    
    /// Callback invoked when the ``isDiscordInstalled(_:)`` function completes
    typealias IsDiscordAppInstalledCallback = @Sendable (_ isInstalled: Bool) -> Void
    
    /// Callback function for when `GetDiscordClientConnectedUser` completes.
    typealias GetDiscordClientConnectedUserCallback = @Sendable (_ result: Result<UserHandle?, ClientResult>)
        -> Void
    
    /// Callback function for ``fetchCurrentUser(token:type:_:)``.
    typealias FetchCurrentUserCallback = @Sendable (_ result: Result<(userID: UInt64, username: String), ClientResult>) -> Void
    
}

// =========================
// MARK: - Audio Callbacks
// =========================

public extension DiscordClient {
    
    // MARK: Audio Devices
    
    /// Callback function for ``currentOutputDevice(_:)``.
    typealias CurrentOutputDeviceCallback = CurrentAudioDeviceCallback
    
    /// Callback function for ``currentInputDevice(_:)``.
    typealias CurrentInputDeviceCallback = CurrentAudioDeviceCallback
    
    /// Callback function for ``outputDevices(_:)``.
    typealias OutputAudioDevicesCallback = AudioDevicesCallback
    
    /// Callback function for ``inputDevices(_:)``.
    typealias InputAudioDevicesCallback = AudioDevicesCallback
    
    /// Callback function for ``onDeviceChange(_:)``.
    typealias AudioDeviceChangedCallback = @Sendable (
        _ input: [AudioDevice],
        _ output: [AudioDevice]
    ) -> Void
    
    /// Callback function for ``setInputDevice(to:_:)-(String,_)``/``setOutputDevice(to:_:)-(String,_)``.
    typealias SetAudioDeviceCallback = ClientResultCallback
    
    /// Callback function for ``onNoAudioInput(_:)``.
    typealias NoAudioInputCallback = @Sendable (_ inputDetected: Bool) -> Void
    
    /// Callback function for ``onVoiceParticipantChanged(_:)``.
    typealias VoiceParticipantChangedCallback = @Sendable (_ lobbyID: UInt64, _ userID: UInt64, _ added: Bool) -> Void
    
    // MARK: Audio Processing
    
    /// Callback function for ``call(lobby:received:captured:)``.
    /// The audio samples in `data` can be modified in-place to achieve simple DSP effects.
    typealias UserAudioReceivedCallback = @Sendable (
        _ userId: UInt64,
        _ data: UnsafeMutablePointer<Int16>?,
        _ samplesPerChannel: UInt64,
        _ sampleRate: Int32,
        _ channels: UInt64,
        _ shouldMute: Bool
    ) -> Void
    
    /// Callback function for ``call(lobby:received:captured:)``.
    /// The audio samples in `data` can be modified in-place to achieve simple DSP effects.
    typealias UserAudioCapturedCallback = @Sendable (
        _ data: UnsafeMutablePointer<Int16>?,
        _ samplesPerChannel: UInt64,
        _ sampleRate: Int32,
        _ channels: UInt64,
    ) -> Void
    
}

// =========================
// MARK: - Auth Callbacks
// =========================

public extension DiscordClient {
    
    /// Callback invoked when the Authorize function completes.
    /// The first arg contains any error message encountered during the authorization flow, such as
    /// if the user cancelled the authorization. The second arg, code, contains an authorization
    /// _code_. This alone cannot be used to authorize with Discord, and instead must be exchanged
    /// for an access token later.
    typealias AuthorizationCallback = @Sendable (_ result: Result<(code: String, redirectURI: String), ClientResult>) -> Void
    
    /// Callback for ``DiscordClient/exchangeChildToken(parentToken:childId:_:)``.
    typealias ExchangeChildTokenCallback = @Sendable (_ result: Result<TokenExchange, ClientResult>) -> Void
    
    /// Callback function for the token exchange APIs such as ``DiscordClient/getToken(application:code:codeVerifier:redirectURI:_:)``
    typealias TokenExchangeCallback = @Sendable (_ result: Result<TokenExchange, ClientResult>) -> Void
    
    /// Callback invoked when a user requests to initiate the authorization flow from the discord app
    /// The callback receives no args and must call the functions needed to initiate the auth flow
    /// as if the user had clicked the account link button in the game
    typealias AuthorizeRequestCallback = VoidCallback
    
    /// Callback function for the ``revokeToken(application:token:_:)`` method.
    typealias RevokeTokenCallback = ClientResultCallback
    
    /// Callback function for ``onAuthorizeDeviceScreenClosed(_:)``.
    typealias AuthorizeDeviceScreenClosedCallback = VoidCallback
    
    /// Callback function for ``onTokenExpiration(_:)``.
    typealias TokenExpirationCallback = VoidCallback
    
    /// Callback function for the ``unmergeIntoProvisionalAccount(application:authType:token:_:)`` method.
    typealias UnmergeIntoProvisionalAccountCallback = ClientResultCallback
    
    /// Callback function for ``updateProvisionalAccountDisplayName(to:_:)``.
    typealias UpdateProvisionalAccountDisplayNameCallback = ClientResultCallback
    
    /// Callback invoked when ``updateToken(to:for:_:)`` completes. Once this is done it is safe to call ``connect()``.
    typealias UpdateTokenCallback = ClientResultCallback
    
    /// Callback function for when ``provisionalUserMergeCompleted(_:)`` completes.
    typealias ProvisionalUserMergeRequiredCallback = VoidCallback
    
    /// Callback function for when ``openConnectedSettings(_:)`` completes.
    typealias OpenConnectedGamesSettingsInDiscordCallback = ClientResultCallback
    
    struct TokenExchange: Sendable {
        public let accessToken: String
        public let refreshToken: String?
        public let tokenType: AuthorizationTokenType
        public let expiresIn: Int32
        public let scopes: String
        
        public init(
            accessToken: String,
            refreshToken: String? = nil,
            tokenType: AuthorizationTokenType,
            expiresIn: Int32,
            scopes: String
        ) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.tokenType = tokenType
            self.expiresIn = expiresIn
            self.scopes = scopes
        }
    }
}

// =========================
// MARK: - Messages Callbacks
// =========================

public extension DiscordClient {
    
    /// Callback function for ``deleteMessage(to:id:_:)``.
    typealias DeleteUserMessageCallback = ClientResultCallback
    
    /// Callback function for ``editMessage(to:id:content:_:)``.
    typealias EditUserMessageCallback = ClientResultCallback
    
    /// Callback function for ``userMessages(to:limit:_:)``.
    typealias UserMessagesWithLimitCallback = MessagesCallback
    
    /// This is used for all kinds of 'send message' calls despite the name, to make sure
    /// engine bindings use the same delegate type declaration for all of them, which makes things
    /// nicer. `SendMessageCallback` was unavailable because it's a macro on Windows.
    typealias SendUserMessageCallback = @Sendable (_ result: Result<UInt64, ClientResult>) -> Void
    
    /// Callback function for ``userMessageSummaries(_:)``.
    typealias UserMessageSummariesCallback = @Sendable (_ result: Result<[UserMessageSummary], ClientResult>) -> Void
    
    /// Callback function for ``onMessageCreated(_:)``.
    typealias MessageCreatedCallback = MessageIdentifierCallback
    
    /// Callback function for ``onMessageDeleted(_:)``.
    typealias MessageDeletedCallback = @Sendable (_ messageID: UInt64, _ channelID: UInt64) -> Void
    
    /// Callback function for ``onMessageUpdated(_:)``.
    typealias MessageUpdatedCallback = MessageIdentifierCallback
    
}

// ===============================
// MARK: - Lobby/Guild Callbacks
// ===============================

public extension DiscordClient {
    
    /// Callback function for ``getLobbyMessagesWithLimit(id:limit:_:)``.
    typealias GetLobbyMessagesCallback = MessagesCallback
    
    /// Callback function for ``createOrJoinLobby(secret:_:)``.
    typealias CreateOrJoinLobbyCallback = @Sendable (_ result: Result<UInt64, ClientResult>) -> Void
    
    /// Callback function for ``joinLinkedLobbyGuild(for:provisionalMerge:body:)``.
    typealias JoinLinkedLobbyGuildCallback = @Sendable (_ result: Result<String, ClientResult>) -> Void
    
    /// Callback function for ``leaveLobby(_:_:)``.
    typealias LeaveLobbyCallback = ClientResultCallback
    
    /// Callback function for ``linkChannelToLobby(channel:lobby:_:)``.
    typealias LinkOrUnlinkChannelCallback = ClientResultCallback
    
    /// Callback function for ``onLobbyCreated(_:)``.
    typealias LobbyCreatedCallback = LobbyIdentifierCallback
    
    /// Callback function for ``onLobbyDeleted(_:)``.
    typealias LobbyDeletedCallback = LobbyIdentifierCallback
    
    /// Callback function for ``onLobbyUpdated(_:)``.
    typealias LobbyUpdatedCallback = LobbyIdentifierCallback
    
    /// Callback function for ``onLobbyMemberAdded(_:)``.
    typealias LobbyMemberAddedCallback = LobbyMemberCallback
    
    /// Callback function for ``onLobbyMemberRemoved(_:)``.
    typealias LobbyMemberRemovedCallback = LobbyMemberCallback
    
    /// Callback function for ``onLobbyMemberUpdated(_:)``.
    typealias LobbyMemberUpdatedCallback = LobbyMemberCallback
    
    /// Callback function for ``guildChannels(for:_:)``.
    typealias GetGuildChannelsCallback = @Sendable (_ result: Result<[GuildChannel], ClientResult>) -> Void
    
    /// Callback function for ``userGuilds(_:)``.
    typealias GetUserGuildsCallback = @Sendable (_ result: Result<[GuildMinimal], ClientResult>) -> Void
    
}

// ===============================
// MARK: - Activity Callbacks
// ===============================

public extension DiscordClient {
    
    /// Callback function for ``acceptActivityInvite(for:_:)``.
    typealias AcceptActivityInviteCallback = @Sendable (_ result: Result<String, ClientResult>) -> Void
    
    /// Callback function for ``sendActivityInvite(to:content:_:)``, ``sendActivityJoinRequest(to:_:)``, and ``sendActivityJoinRequestReply(for:_:)``.
    typealias SendActivityInviteCallback = ClientResultCallback
    
    /// Callback function for ``onActivityInviteCreated(_:)`` and ``onActivityInviteUpdated(_:)``.
    typealias ActivityInviteCallback = @Sendable (_ invite: ActivityInvite) -> Void
    
    /// Callback function for `SetActivityCallback`.
    typealias ActivityJoinCallback = @Sendable (_ joinSecret: String) -> Void
    
    /// Callback function for ``onActivityJoinWithApp(_:)``.
    typealias ActivityJoinWithApplicationCallback = @Sendable (_ applicationID: UInt64, _ joinSecret: String) -> Void
    
}

// ===============================
// MARK: - Relationships Callbacks
// ===============================

public extension DiscordClient {
    
    /// Callback function for most other Relationship functions such as ``sendDiscordFriendRequest(to:_:)-(UInt64,_)``.
    typealias UpdateRelationshipCallback = ClientResultCallback
    
    /// Callback function for ``sendDiscordFriendRequest(to:_:)-(String,_)`` and ``sendGameFriendRequest(to:_:)-(String,_)``.
    typealias SendFriendRequestCallback = ClientResultCallback
    
    /// Callback function for ``onRelationshipCreated(_:)``.
    /// `isDiscordRelationshipUpdate` will be true if the relationship created with the `userId` is a Discord relationship, and false if it's an in-game relationship.
    typealias RelationshipCreatedCallback = RelationshipCallback
    
    /// Callback function for ``onRelationshipDeleted(_:)``
    /// `isDiscordRelationshipUpdate` will be true if the relationship deleted with the `userId` is a Discord relationship, and false if it's an in-game relationship.
    typealias RelationshipDeletedCallback = RelationshipCallback
    
    /// Callback function for ``onRelationshipCreated(_:)``.
    typealias RelationshipGroupsUpdatedCallback = UserIdentifierCallback
    
}

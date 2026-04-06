//
//  Client+Async.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 4/5/26.
//

@_implementationOnly import discord_partner_sdk

#if asyncCallbacks

    // ===============
    // MARK: - Audio
    // ===============

    extension DiscordClient {

        /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
        public func endCall(channel id: UInt64) async {
            await withCheckedContinuation { cont in
                endCall(channel: id) { cont.resume() }
            }
        }

        /// Ends any active call, if any. Any references you have to Call objects are invalid after they are ended, and can be immediately freed.
        public func endCalls() async {
            await withCheckedContinuation { cont in
                endCalls { cont.resume() }
            }
        }

        /// Asynchronously changes the audio input device in use by the client to the specified device.
        ///
        /// You can find the list of device IDs that can be passed in with ``inputDevices(_:)``.
        public func setInputDevice(to id: String) async throws {
            try await withCheckedThrowingContinuation { cont in
                setInputDevice(to: id) { cont.resume(with: $0) }
            }
        }

        /// Asynchronously changes the audio output device in use by the client to the specified device.
        ///
        /// You can find the list of device IDs that can be passed in with ``outputDevices(_:)``.
        public func setOutputDevice(to id: String) async throws {
            try await withCheckedThrowingContinuation { cont in
                setOutputDevice(to: id) { cont.resume(with: $0) }
            }
        }

    }

    // ===============
    // MARK: - Auth
    // ===============

    extension DiscordClient {

        public func authorize(with args: AuthorizationArgs) async throws -> (
            code: String, redirectURI: String
        ) {
            try await withCheckedThrowingContinuation { cont in
                authorize(with: args) { cont.resume(with: $0) }
            }
        }

        public func provisionalToken(
            application id: UInt64,
            type: AuthenticationExternalAuthType,
            token: String
        ) async throws -> TokenExchange {
            try await withCheckedThrowingContinuation { cont in
                getProvisionalToken(
                    application: id,
                    authType: type,
                    token: token
                ) { cont.resume(with: $0) }
            }
        }

        public func refreshToken(application id: UInt64, token: String)
            async throws -> TokenExchange
        {
            try await withCheckedThrowingContinuation { cont in
                refreshToken(application: id, token: token) {
                    cont.resume(with: $0)
                }
            }
        }

        public func getToken(
            application id: UInt64,
            code: String,
            codeVerifier: String,
            redirectURI: String
        ) async throws -> TokenExchange {
            try await withCheckedThrowingContinuation { cont in
                getToken(
                    application: id,
                    code: code,
                    codeVerifier: codeVerifier,
                    redirectURI: redirectURI
                ) {
                    cont.resume(with: $0)
                }
            }
        }

        public func getTokenFromDevice(with args: DeviceAuthorizationArgs)
            async throws -> TokenExchange
        {
            try await withCheckedThrowingContinuation { cont in
                getTokenFromDevice(args: args) { cont.resume(with: $0) }
            }
        }

        public func getTokenFromDeviceProvisionalMerge(
            args: DeviceAuthorizationArgs,
            authType: AuthenticationExternalAuthType,
            token: String
        ) async throws -> TokenExchange {
            try await withCheckedThrowingContinuation { cont in
                getTokenFromDeviceProvisionalMerge(
                    args: args,
                    authType: authType,
                    token: token
                ) { cont.resume(with: $0) }
            }
        }

        public func getTokenFromProvisionalMerge(
            application id: UInt64,
            code: String,
            verifier: String,
            redirectUri: String,
            authType: AuthenticationExternalAuthType,
            token: String
        ) async throws -> TokenExchange {
            try await withCheckedThrowingContinuation { cont in
                getTokenFromProvisionalMerge(
                    application: id,
                    code: code,
                    verifier: verifier,
                    redirectUri: redirectUri,
                    authType: authType,
                    token: token
                ) { cont.resume(with: $0) }
            }
        }

        public func revokeToken(application id: UInt64, token: String)
            async throws
        {
            try await withCheckedThrowingContinuation { cont in
                revokeToken(application: id, token: token) {
                    cont.resume(with: $0)
                }
            }
        }

        public func unmergeIntoProvisionalAccount(
            application id: UInt64,
            authType: AuthenticationExternalAuthType,
            token: String
        ) async throws {
            try await withCheckedThrowingContinuation { cont in
                unmergeIntoProvisionalAccount(
                    application: id,
                    authType: authType,
                    token: token,
                ) { cont.resume(with: $0) }
            }
        }

        public func updateProvisionalAccountDisplayName(to name: String)
            async throws
        {
            return try await withCheckedThrowingContinuation { continuation in
                updateProvisionalAccountDisplayName(to: name) { result in
                    continuation.resume(with: result)
                }
            }
        }

        public func updateToken(
            to token: String,
            for type: AuthorizationTokenType
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                updateToken(to: token, for: type) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    // ===============
    // MARK: - Chat
    // ===============

    extension DiscordClient {

        func deleteMessage(
            to reciepientID: UInt64,
            id msgID: UInt64
        ) async throws {
            try await withCheckedThrowingContinuation { cont in
                deleteMessage(to: reciepientID, id: msgID) {
                    cont.resume(with: $0)
                }
            }
        }

        public func editMessage(
            to reciepientID: UInt64,
            id msgID: UInt64,
            content: String
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                editMessage(to: reciepientID, id: msgID, content: content) {
                    result in
                    continuation.resume(with: result)
                }
            }
        }

        public func sendMessage(
            to recipientID: UInt64,
            content: String
        ) async throws -> UInt64 {
            return try await withCheckedThrowingContinuation { continuation in
                sendMessage(to: recipientID, content: content) { result in
                    continuation.resume(with: result)
                }
            }
        }

        public func sendMessage(
            to recipientID: UInt64,
            content: String,
            metadata: [String: String]
        ) async throws -> UInt64 {
            return try await withCheckedThrowingContinuation { continuation in
                sendMessage(
                    to: recipientID,
                    content: content,
                    metadata: metadata
                ) { result in
                    continuation.resume(with: result)
                }
            }
        }

        public func userMessageSummaries() async throws -> [UserMessageSummary]
        {
            return try await withCheckedThrowingContinuation { continuation in
                userMessageSummaries { result in
                    continuation.resume(with: result)
                }
            }
        }

        public func userMessages(
            to recipientID: UInt64,
            limit: Int32
        ) async throws -> [MessageHandle] {
            return try await withCheckedThrowingContinuation { continuation in
                userMessages(to: recipientID, limit: limit) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    // ===============
    // MARK: - Core
    // ===============

    extension DiscordClient {

        public func fetchCurrentUser(
            token: String,
            type: AuthorizationTokenType
        ) async throws -> (userID: UInt64, username: String) {
            return try await withCheckedThrowingContinuation { continuation in
                fetchCurrentUser(token: token, type: type) { result in
                    continuation.resume(with: result)
                }
            }
        }

        public func openConnectedSettings() async throws {
            return try await withCheckedThrowingContinuation { continuation in
                openConnectedSettings { result in
                    continuation.resume(with: result)
                }
            }
        }

        public func clientConnectedUser(for application: UInt64) async throws
            -> UserHandle?
        {
            return try await withCheckedThrowingContinuation { continuation in
                clientConnectedUser(for: application) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    // ===============
    // MARK: - Lobbies
    // ===============

    extension DiscordClient {

        func getLobbyMessagesWithLimit(
            id: UInt64,
            limit: Int32
        ) async throws -> [MessageHandle] {
            return try await withCheckedThrowingContinuation { continuation in
                getLobbyMessagesWithLimit(id: id, limit: limit) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendLobbyMessage(
            id: UInt64,
            content: String
        ) async throws -> UInt64 {
            return try await withCheckedThrowingContinuation { continuation in
                sendLobbyMessage(id: id, content: content) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendLobbyMessage(
            to lobby: UInt64,
            message: String,
            metadata: [String: String]
        ) async throws -> UInt64 {
            return try await withCheckedThrowingContinuation { continuation in
                sendLobbyMessage(
                    to: lobby,
                    message: message,
                    metadata: metadata
                ) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func createOrJoinLobby(
            secret: String
        ) async throws -> UInt64 {
            return try await withCheckedThrowingContinuation { continuation in
                createOrJoinLobby(secret: secret) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func createOrJoinLobby(
            secret: String,
            lobby: [String: String],
            member: [String: String]
        ) async throws -> UInt64 {
            return try await withCheckedThrowingContinuation { continuation in
                createOrJoinLobby(secret: secret, lobby: lobby, member: member)
                { result in
                    continuation.resume(with: result)
                }
            }
        }

        func guildChannels(
            for guildId: UInt64
        ) async throws -> [GuildChannel] {
            return try await withCheckedThrowingContinuation { continuation in
                guildChannels(for: guildId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func userGuilds() async throws -> [GuildMinimal] {
            return try await withCheckedThrowingContinuation { continuation in
                userGuilds { result in
                    continuation.resume(with: result)
                }
            }
        }

        func leaveLobby(
            _ id: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                leaveLobby(id) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func joinLinkedLobbyGuild(
            for id: UInt64,
            provisionalMerge: @escaping ProvisionalUserMergeRequiredCallback
        ) async throws -> String {
            return try await withCheckedThrowingContinuation { continuation in
                joinLinkedLobbyGuild(
                    for: id,
                    provisionalMerge: provisionalMerge
                ) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func linkChannelToLobby(
            channel: UInt64,
            lobby: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                linkChannelToLobby(channel: channel, lobby: lobby) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func unlinkChannelFromLobby(
            lobby: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                unlinkChannelFromLobby(lobby: lobby) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    // ===============
    // MARK: - Presence
    // ===============

    extension DiscordClient {

        func acceptActivityInvite(
            for invite: ActivityInvite
        ) async throws -> String {
            return try await withCheckedThrowingContinuation { continuation in
                acceptActivityInvite(for: invite) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendActivityInvite(
            to id: UInt64,
            content: String
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendActivityInvite(to: id, content: content) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendActivityJoinRequest(
            to id: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendActivityJoinRequest(to: id) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendActivityJoinRequestReply(
            for invite: ActivityInvite
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendActivityJoinRequestReply(for: invite) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func setOnlineStatus(
            to status: StatusType
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                setOnlineStatus(to: status) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func updateRichPresence(
            to activity: Activity
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                updateRichPresence(to: activity) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    // ===============
    // MARK: - Relationships
    // ===============

    extension DiscordClient {

        func acceptDiscordFriendRequest(
            from userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                acceptDiscordFriendRequest(from: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func acceptGameFriendRequest(
            from userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                acceptGameFriendRequest(from: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func cancelDiscordFriendRequest(
            to userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                cancelDiscordFriendRequest(to: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func cancelGameFriendRequest(
            to userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                cancelGameFriendRequest(to: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func rejectDiscordFriendRequest(
            from userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                rejectDiscordFriendRequest(from: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func rejectGameFriendRequest(
            from userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                rejectGameFriendRequest(from: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func removeDiscordAndGameFriend(
            _ userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                removeDiscordAndGameFriend(userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func removeGameFriend(
            _ userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                removeGameFriend(userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendDiscordFriendRequest(
            to username: String
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendDiscordFriendRequest(to: username) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendDiscordFriendRequest(
            to userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendDiscordFriendRequest(to: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendGameFriendRequest(
            to username: String
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendGameFriendRequest(to: username) { result in
                    continuation.resume(with: result)
                }
            }
        }

        func sendGameFriendRequest(
            to userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                sendGameFriendRequest(to: userId) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    // ===============
    // MARK: - Users
    // ===============

    extension DiscordClient {

        func blockUser(
            _ userId: UInt64
        ) async throws {
            return try await withCheckedThrowingContinuation { continuation in
                blockUser(userId) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }


// ===============
// MARK: - onXXX
// ===============

public extension DiscordClient {

    // MARK: Core
    
    /// Adds a callback function to be invoked for each new log message generated by the SDK.
    ///
    /// This function excludes most logs related to voice and WebRTC activity, as those tend to be
    /// significantly more verbose and may require a different logging level. Instead, it includes
    /// logs for systems such as lobbies, relationships, presence, and authentication.
    ///
    /// It is strongly recommended to invoke this function immediately after constructing the Client
    /// object.
    ///
    /// - Parameters:
    ///   - severity: The minimum logging severity to receive.
    ///   - body: Callback invoked for each log message.
    func onLog(
        of severity: LoggingSeverity = .info,
        _ body: @escaping @Sendable (_ message: String, _ severity: LoggingSeverity) async throws -> Void
    ) {
        onLog(of: severity) { msg, sev in
            Task { try await body(msg, sev) }
        }
    }
    
    /// Adds a callback function to be invoked for each new log message generated by the
    /// voice subsystem of the SDK, including the underlying webrtc infrastructure.
    ///
    /// We strongly recommend invoking this function immediately after constructing the Client object.
    ///
    /// - Parameters:
    ///   - severity: The minimum logging severity to receive.
    ///   - body: Callback invoked for each log message.
    func onVoiceLog(
        of severity: LoggingSeverity = .info,
        _ body: @escaping @Sendable (_ message: String, _ severity: LoggingSeverity) async throws -> Void
    ) {
        onVoiceLog(of: severity) { msg, sev in
            Task { try await body(msg, sev) }
        }
    }
    
    /// Callback to be invoked whenever the SDKs status changes.
    func onStatusChanged(
        _ body: @escaping @Sendable (_ result: Result<ClientStatus, ClientError>) async throws -> Void
    ) {
        onStatusChanged { result in
            Task { try await body(result) }
        }
    }
    
    // MARK: Audio
    
    /// Sets a callback to be invoked when Discord detects a change in the available audio devices.
    func onDeviceChange(
        _ body: @escaping @Sendable (_ input: [AudioDevice], _ output: [AudioDevice]) async throws -> Void
    ) {
        onDeviceChange { i, o in
            Task { try await body(i, o) }
        }
    }
    
    /// Callback invoked whenever a user in a lobby joins or leaves a voice call.
    ///
    /// The main use case for this is to enable displaying which users are in voice in a lobby
    /// even if the current user is not in voice yet, and thus does not have a Call object to bind to.
    func onVoiceParticipantChanged(
        _ body: @escaping @Sendable (_ lobbyID: UInt64, _ userID: UInt64, _ added: Bool) async throws -> Void
    ) {
        onVoiceParticipantChanged { lobbyID, userID, added in
            Task { try await body(lobbyID, userID, added) }
        }
    }
    
    /// Threshold that can be set to indicate when no audio is being received by the user's mic.
    ///
    /// An example of when this may be useful: When push to talk is being used and the user pushes
    /// their talk key, but something is configured wrong and no audio is being received, this
    /// threshold and callback can be used to detect that situation and notify the user. The
    /// threshold is specified in DBFS, or decibels relative to full scale, and the range is
    /// [-100.0, 100.0] It defaults to -100.0, so is disabled.
    func onNoAudioInput(
        _ body: @escaping @Sendable (_ inputDetected: Bool) async throws -> Void
    ) {
        onNoAudioInput { inputDetected in
            Task { try await body(inputDetected) }
        }
    }
    
    // MARK: Auth
    
    /// Get a notification when the current token is about to expire or expired.
    ///
    /// This callback is invoked when the SDK detects that the last token passed to
    /// ``updateToken(to:for:_:)`` is nearing expiration or has expired. This is a signal to the developer
    /// to refresh the token. The callback is invoked once per token, and will not be invoked again
    /// until a new token is passed to Client::UpdateToken.
    ///
    /// If the token is refreshed before the expiration callback is invoked, call
    /// ``updateToken(to:for:_:)`` to pass in the new token and reconfigure the token expiration.
    ///
    /// If your client is disconnected (the token was expired when connecting or was revoked while
    /// connected), the expiration callback will not be invoked.
    func onTokenExpiration(
        _ body: @escaping @Sendable () async throws -> Void
    ) {
        onTokenExpiration {
            Task { try await body() }
        }
    }
    
    /// Sets a callback to be invoked when the device authorization screen is closed.
    func onAuthorizeDeviceScreenClosed(
        _ body: @escaping @Sendable () async throws -> Void
    ) {
            onAuthorizeDeviceScreenClosed {
            Task { try await body() }
        }
    }
    
    /// Registers a callback to be invoked when a user requests to initiate the authorization flow.
    ///
    /// When you register this callback, the Discord app will show new entry points to allow users
    /// to initiate the authorization flow.
    ///
    /// This function is tied to upcoming Discord client functionality experiments that will be
    /// rolled out to a percentage of Discord users over time. More documentation and implementation
    /// details to come as the client experiments run.
    func onAuthorizationRequest(
        _ body: @escaping @Sendable () async throws -> Void
    ) {
        onAuthorizationRequest {
            Task { try await body() }
        }
    }
    
    // MARK: Chat
    
    /// Sets a callback to be invoked whenever a new message is received in either a lobby or a direct message.
    ///
    /// From the `messageId`, you can fetch the ``MessageHandle`` and then the ``ChannelHandle``
    /// to determine where the message was sent.
    ///
    /// If the user has the Discord desktop application open on the same machine as the game,
    /// they will hear notifications from the Discord application, even though they can see
    /// those messages in game. To avoid duplicate notifications, you should call
    /// ``DiscordClient/showChat(_:)`` whenever the chat is shown or hidden.
    ///
    /// - Parameter body: Callback invoked when a new message is created.
    func onMessageCreated(
        _ body: @escaping @Sendable (_ messageID: UInt64) async throws -> Void
    ) {
        onMessageCreated { id in
            Task { try await body(id) }
        }
    }
    
    /// Sets a callback to be invoked whenever a message is deleted.
    ///
    /// Some messages sent from in game, as well as all messages sent from a connected user's
    /// Discord client, can be edited and deleted in the Discord client. It is recommended to
    /// implement support for this callback so that deletions are reflected in game as well.
    ///
    /// - Parameter body: Callback invoked when a message is deleted.
    func onMessageDeleted(
        _ body: @escaping @Sendable (_ messageID: UInt64, _ channelID: UInt64) async throws -> Void
    ) {
        onMessageDeleted { mId, cId in
            Task { try await body(mId, cId) }
        }
    }
    
    /// Sets a callback to be invoked whenever a message is edited.
    ///
    /// Some messages sent from in game, as well as all messages sent from a connected user's
    /// Discord client, can be edited and deleted in the Discord client. It is recommended to
    /// implement support for this callback so that edits are reflected in game as well.
    ///
    /// - Parameter body: Callback invoked when a message is updated.
    func onMessageUpdated(
        _ body: @escaping @Sendable (_ messageID: UInt64) async throws -> Void
    ) {
        onMessageUpdated { id in
            Task { try await body(id) }
        }
    }
    
    // MARK: Lobbies
    
    /// Sets a callback to be invoked when a lobby becomes available to the client.
    ///
    /// A lobby can become available in several situations:
    /// - A new lobby is created and the current user is a member.
    /// - The current user is added to an existing lobby.
    /// - A lobby recovers after a backend crash and becomes available again.
    ///
    /// This means the callback can be invoked more than once in a single session.
    /// Typically, it should not be invoked twice consecutively. For example, if a lobby
    /// crashes or the user is removed, you should expect the corresponding deletion
    /// callback to be invoked first.
    ///
    /// - Parameter body: Callback invoked when a lobby becomes available.
    func onLobbyCreated(
        _ body: @escaping @Sendable (_ lobbyID: UInt64) async throws -> Void
    ) {
        onLobbyCreated { id in
            Task { try await body(id) }
        }
    }
    
    /// Sets a callback to be invoked when a lobby is no longer available.
    ///
    /// This callback can be invoked in several situations:
    /// - A lobby the user is a member of is deleted.
    /// - The current user is removed from a lobby.
    /// - A backend failure causes the lobby to become unavailable.
    ///
    /// This callback may be invoked even if the lobby still exists for other users.
    ///
    /// - Parameter body: Callback invoked when a lobby becomes unavailable.
    func onLobbyDeleted(
        _ body: @escaping @Sendable (_ lobbyID: UInt64) async throws -> Void
    ) {
        onLobbyDeleted { id in
            Task { try await body(id) }
        }
    }
    
    /// Sets a callback to be invoked when a lobby is updated, such as when its metadata changes.
    ///
    /// - Parameter body: Callback invoked when a lobby is modified.
    func onLobbyUpdated(
        _ body: @escaping @Sendable (_ lobbyID: UInt64) async throws -> Void
    ) {
        onLobbyUpdated { id in
            Task { try await body(id) }
        }
    }
    
    /// Sets a callback function to be invoked whenever a user is added to a lobby.
    ///
    /// This callback is not invoked when the current user is added to a lobby. In that case,
    /// the `onLobbyCreated` callback is invoked instead. Additionally, the SDK distinguishes
    /// between lobby membership and connection state. A user being added does not necessarily
    /// mean they are currently online or connected, only that they have permission to join.
    ///
    /// - Parameter body: Callback invoked when a user is added to a lobby.
    func onLobbyMemberAdded(
        _ body: @escaping @Sendable (_ lobbyID: UInt64, _ memberID: UInt64) async throws -> Void
    ) {
        onLobbyMemberAdded { lid, mId in
            Task { try await body(lid, mId) }
        }
    }
    
    /// Sets a callback function to be invoked whenever a member of a lobby is removed
    /// and can no longer connect to it.
    ///
    /// This callback is not invoked when the current user is removed from a lobby. In that case,
    /// the `onLobbyDeleted` callback is invoked instead. This callback is also not triggered when
    /// a user simply exits the game. In that scenario, `onLobbyMemberUpdated` is invoked, and the
    /// ``LobbyMemberHandle`` will indicate that the user is no longer connected.
    ///
    /// - Parameter body: Callback invoked when a user is removed from a lobby.
    func onLobbyMemberRemoved(
        _ body: @escaping @Sendable (_ lobbyID: UInt64, _ memberID: UInt64) async throws -> Void
    ) {
        onLobbyMemberRemoved { lid, mId in
            Task { try await body(lid, mId) }
        }
    }
    
    /// Sets a callback function to be invoked whenever a member of a lobby is updated.
    ///
    /// This callback is invoked when:
    /// - A user connects or disconnects.
    /// - The metadata of a member changes.
    ///
    /// - Parameter body: Callback invoked when a lobby member is updated.
    func onLobbyMemberUpdated(
        _ body: @escaping @Sendable (_ lobbyID: UInt64, _ memberID: UInt64) async throws -> Void
    ) {
        onLobbyMemberUpdated { lid, mId in
            Task { try await body(lid, mId) }
        }
    }
    
    // MARK: Activities
    
    /// Sets a callback function that is invoked when the current user receives an activity
    /// invite from another user.
    ///
    /// These invites are always sent as messages, so the SDK is parsing these
    /// messages to look for invites and invokes this callback instead. The message create callback
    /// will not be invoked for these messages. The invite object contains all the necessary
    /// information to identity the invite, which you can later pass to ``acceptActivityInvite(for:_:)``.
    func onActivityInviteCreated(
        _ body: @escaping @Sendable (_ invite: ActivityInvite) async throws -> Void
    ) {
        onActivityInviteCreated { inv in
            Task { try await body(inv) }
        }
    }
    
    /// Sets a callback function that is invoked when an existing activity invite changes.
    ///
    /// Currently, the only thing that changes on an activity invite is its validity. If the sender
    /// goes offline or exits the party the receiver was invited to, the invite is no longer
    /// joinable. It is possible for an invalid invite to go from invalid to valid if the sender
    /// rejoins the activity.
    func onActivityInviteUpdated(
        _ body: @escaping @Sendable (_ invite: sending ActivityInvite) async throws -> Void
    ) {
        onActivityInviteUpdated { inv in
            Task { try await body(inv) }
        }
    }
    
    /// Sets a callback function that is invoked when the current user also has Discord
    /// running on their computer and they accept an activity invite in the Discord client.
    ///
    /// This callback is invoked with the join secret from the activity rich presence, which you can
    /// use to join them to the game's internal party system. See ``Activity`` for more information on
    /// invites.
    func onActivityJoined(
        _ body: @escaping @Sendable (_ joinSecret: String) async throws -> Void
    ) {
        onActivityJoined { s in
            Task { try await body(s) }
        }
    }
    
    /// Sets a callback function that is invoked when the current user also has Discord
    /// running on their computer and they accept an activity invite in the Discord client.
    ///
    /// This callback is invoked with the join secret from the activity rich presence, which you can
    /// use to join them to the game's internal party system. See ``Activity`` for more information on invites.
    func onActivityJoinedWithApp(
        _ body: @escaping @Sendable (_ applicationID: UInt64 ,_ joinSecret: String) async throws -> Void
    ) {
        onActivityJoinedWithApp { app, sec in
            Task { try await body(app, sec) }
        }
    }
    
    // MARK: Relationships
    
    /// Sets a callback to be invoked whenever a relationship for this user is established or changes type.
    ///
    /// This can be invoked when a user sends or accepts a friend invite or blocks a user for example.
    func onRelationshipCreated(
        _ body: @escaping @Sendable (_ userID: UInt64,_ isDiscordRelationshipUpdate: Bool) async throws -> Void
    ) {
        onRelationshipCreated { uid, update in
            Task { try await body(uid, update) }
        }
    }
    
    /// Sets a callback to be invoked whenever a relationship for this user is removed, such as when the user rejects a friend request or removes a friend.
    ///
    /// When a relationship is removed, ``relationshipHandle(for:)`` will return a relationship with the type set to ``RelationshipType/none``.
    func onRelationshipDeleted(
        _ body: @escaping @Sendable (_ userID: UInt64,_ isDiscordRelationshipUpdate: Bool) async throws -> Void
    ) {
        onRelationshipDeleted { uid, update in
            Task { try await body(uid, update) }
        }
    }
    
    /// Sets a callback to be invoked whenever the relationship groups for a user change.
    ///
    /// This is typically useful for refreshing grouped relationship UI for the affected user.
    ///
    /// - Parameter body: Callback invoked with the updated user id.
    func onRelationshipGroupsUpdated(
        _ body: @escaping @Sendable (_ userId: UInt64) async throws -> Void
    ) {
        onRelationshipGroupsUpdated { id in
            Task { try await body(id) }
        }
    }
    
    /// Sets a callback to be invoked whenever a cached user is updated.
    ///
    /// - Parameter body: Callback invoked with the updated user id.
    func onUserUpdated(
        _ body: @escaping @Sendable (_ userId: UInt64) async throws -> Void
    ) {
        onUserUpdated { id in
            Task { try await body(id) }
        }
    }
    
}


#endif

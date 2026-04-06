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

        /// Asynchronously fetches the current audio input device in use by the client.
        public func currentInputDevice() async -> AudioDevice {
            await withCheckedContinuation { cont in
                currentInputDevice { dev in
                    cont.resume(returning: dev)
                }
            }
        }

        /// Asynchronously fetches the current audio output device in use by the client.
        public func currentOutputDevice() async -> AudioDevice {
            await withCheckedContinuation { cont in
                currentOutputDevice { dev in
                    cont.resume(returning: dev)
                }
            }
        }

        /// Asynchronously fetches the list of audio input devices available to the user.
        public func inputDevices() async -> [AudioDevice] {
            await withCheckedContinuation { cont in
                inputDevices { devs in
                    cont.resume(returning: devs)
                }
            }
        }

        /// Asynchronously fetches the list of audio output devices available to the user.
        public func outputDevices() async -> [AudioDevice] {
            await withCheckedContinuation { cont in
                outputDevices { devs in
                    cont.resume(returning: devs)
                }
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

        @available(iOS 18.5, *)
        @available(Android 11.0, *)
        public func isDiscordInstalled() async -> Bool {
            return await withCheckedContinuation { continuation in
                isDiscordInstalled { result in
                    continuation.resume(returning: result)
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

#endif

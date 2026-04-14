//
//  DiscordClient.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk
public import Foundation

public final class DiscordClient: DiscordObject, @unchecked Sendable {
    private var persistent = PersistentCallbacks()
    var storage: DiscordStorage<Discord_Client>
    init(storage: DiscordStorage<Discord_Client>) {
        self.storage = storage
        _ = authorizationCodeVerifier
    }

    public init() {
        self.storage = .init()
        _ = authorizationCodeVerifier
    }

    public init(options: Options) {
        self.storage = options.storage.withLock { raw in
            var client = Discord_Client()
            Discord_Client_InitWithOptions(&client, &raw)
            return DiscordStorage(takingOwnership: client)
        }
        _ = authorizationCodeVerifier // doing this bc the lazy var is unsafe so we init it first before any accesses
    }

    public init(api: String, base: String) {
        self.storage = api.withDiscordString { dApi in
            base.withDiscordString { bApi in
                var client = Discord_Client()
                Discord_Client_InitWithBases(
                    &client,
                    dApi,
                    bApi
                )
                return DiscordStorage(takingOwnership: client)
            }
        }
        _ = authorizationCodeVerifier
    }

    // MARK: Properties

    /// This is used to get the application ID for the client and identify the application to the Discord client.
    /// This is used for things like authentication, rich presence, and activity invites when *not* connected with
    /// ``connect()``. When calling ``connect()``, the application ID is set automatically
    public var applicationId: UInt64 {
        get { usingLock { $0.getApplicationId() } }
        set { usingLock { $0.setApplicationId(newValue) } }
    }

    /// Input volume for the current user's microphone.
    /// Input volume is specified as a percentage in the range [0, 100] which represents the perceptual loudness.
    public var inputVolume: Float {
        get { usingLock { $0.getInputVolume() } }
        set { usingLock { $0.setInputVolume(newValue) } }
    }

    /// Output volume for the current user.
    /// Output volume specified as a percentage in the range [0, 200] which represents the perceptual loudness.
    public var outputVolume: Float {
        get { usingLock { $0.getOutputVolume() } }
        set { usingLock { $0.setOutputVolume(newValue) } }
    }

    /// Whether the current user is deafened in all calls.
    public var isDeafEverywhere: Bool {
        get { usingLock { $0.getSelfDeafAll() } }
        set { usingLock { $0.setSelfDeafAll(newValue) } }
    }

    /// Whether the current user is deafened in all calls.
    public var isMutedEverywhere: Bool {
        get { usingLock { $0.getSelfMuteAll() } }
        set { usingLock { $0.setSelfMuteAll(newValue) } }
    }

    /// Returns true if the SDK has a non-empty OAuth2 token set, regardless of whether that token is valid or not.
    public var isAuthenticated: Bool {
        usingLock { $0.isAuthenticated() }
    }

    /// Current status of the client.
    public var status: ClientStatus {
        usingLock { $0.getStatus().swiftValue }
    }

    /// Returns a list of all lobbies that the user is a member of and that the SDK has loaded.
    ///
    /// Lobbies are optimistically loaded when the SDK starts, but in some cases may not be
    /// immediately available after the SDK status changes to ``ClientStatus/ready``.
    public var lobbyIds: [UInt64] {
        storage.withLock { raw in
            var span = Discord_UInt64Span()
            raw.getLobbyIds(&span)
            return span.converting()
        }
    }

    public var currentUser: UserHandle? {
        storage.withLock { raw in
            var handle = Discord_UserHandle()
            return raw.getCurrentUserV2(&handle) ? UserHandle(takingOwnership: handle) : nil
        }
    }
    
    /// A list of all of the relationships the current user has with others, including all Discord relationships and all Game relationships for the current game.
    public var relationships: [RelationshipHandle] {
        storage.withLock { raw in
            var span = Discord_RelationshipHandleSpan()
            raw.getRelationships(&span)
            return span.converting()
        }
    }
    
    
    @ThreadSafe private var autoGain = true

    /// Automatically adjusts the microphone volume to keep it clear and consistent.
    /// - remark: Defaults to on. Generally this shouldn't need to be used unless you
    /// are building a voice settings UI for the user to control, similar to Discord's voice settings.
    public var isAutoGainEnabled: Bool {
        get { autoGain }
        set {
            $autoGain.withLock { gain in
                gain = newValue
                storage.withLock { raw in
                    raw.setAutomaticGainControl(gain)
                }
            }
        }
    }

    @ThreadSafe private var echoCancel = true

    /// Basic echo cancellation provided by the WebRTC library.
    /// - remark: Defaults to on. Generally this shouldn't need to be used unless you
    /// are building a voice settings UI for the user to control, similar to Discord's voice settings.
    public var isEchoCancelling: Bool {
        get { echoCancel }
        set {
            $echoCancel.withLock { echo in
                echo = newValue
                usingLock { $0.setEchoCancellation(echo) }
            }
        }
    }

    @ThreadSafe private var engineManaged: Bool = false

    /// On mobile devices, set whether the audio environment is managed by the engine or the SDK.
    /// On Android, this entails AudioManager state and on iOS, this entails AVAudioSession activation.
    ///
    /// This method must be called before connecting to any Calls if the
    /// application manages audio on its own, otherwise audio management
    /// will be ended by the voice engine when the last Call is ended.
    ///
    /// The Unity plugin automatically calls this method if the native Unity
    /// audio engine is enabled in the project settings.
    ///
    @available(iOS 18.5, *)
    @available(Android 11.0, *)
    public var isAudioEngineManagedSession: Bool {
        get { engineManaged }
        set {
            $engineManaged.withLock { engine in
                engine = newValue
                usingLock { $0.setEngineManagedAudioSession(engine) }
            }
        }
    }

    @ThreadSafe private var audioDBFS: Float = -100.0

    /// Threshold to indicate when no audio is being received by the user's mic.
    ///
    /// An example of when this may be useful: When push to talk is being used and the user pushes
    /// their talk key, but something is configured wrong and no audio is being received, this
    /// threshold and callback can be used to detect that situation and notify the user. The
    /// threshold is specified in DBFS, or decibels relative to full scale, and the range is
    /// [-100.0, 100.0] It defaults to -100.0, so is disabled.
    public var noAudioInputThreshold: Float {
        get { audioDBFS }
        set {
            $audioDBFS.withLock { dbfs in
                dbfs = newValue
                usingLock { $0.setNoAudioInputThreshold(dbfs) }
            }
        }
    }

    @ThreadSafe private var supressingNoise: Bool = true

    /// Enables basic background noise suppression.
    /// - remark: Defaults to on.
    /// Generally this shouldn't need to be used unless you are building a voice
    /// settings UI for the user to control, similar to Discord's voice settings.
    public var isNoiseSupressing: Bool {
        get { supressingNoise }
        set {
            $supressingNoise.withLock { noise in
                noise = newValue
                usingLock { $0.setNoiseSuppression(noise) }
            }
        }
    }
    
    
    @ThreadSafe private var opusHardware: (encoding: Bool, decoding: Bool) = (true, true)
    
    /// Opus hardware encoding/decoding for audio, if available.
    /// - remark: Defaults to on. This must be called immediately
    ///           after constructing the Client. If called too late an error
    ///           will be logged and the setting will not take effect.
    public var opusHardwareAcceleration: (encoding: Bool, decoding: Bool) {
        get { opusHardware }
        set {
            $opusHardware.withLock { opus in
                opus = newValue
                usingLock { $0.setOpusHardwareCoding(opus.encoding, opus.decoding) }
            }
        }
    }
    

//    @ThreadSafe private var opusEncoding: Bool = true
//
//    /// Opus hardware encoding for audio, if available.
//    /// - remark: Defaults to on. This must be called immediately
//    /// 		  after constructing the Client. If called too late an error
//    /// 		  will be logged and the setting will not take effect.
//    public var opusEncodingEnabled: Bool {
//        get { opusEncoding }
//        set {
//            opusEncoding = newValue
//            usingLock(Discord_Client_SetOpusHardwareCoding, opusEncoding, opusDecoding)
//        }
//    }
//
//    @ThreadSafe private var opusDecoding: Bool = true
//
//    /// Opus hardware decoding for audio, if available.
//    /// - remark: Defaults to on. This must be called immediately
//    ///           after constructing the Client. If called too late an error
//    ///           will be logged and the setting will not take effect.
//    public var opusDecodingEnabled: Bool {
//        get { opusEncoding }
//        set {
//            opusEncoding = newValue
//            usingLock(Discord_Client_SetOpusHardwareCoding, opusEncoding, opusDecoding)
//        }
//    }

    /// Authorization helper property that can create a code challenge and verifier.
    ///
    /// Used in the ``authorize(with:_:)`` + ``getToken(application:code:codeVerifier:redirectURI:_:)`` flow.
    /// This returns a struct with two items, a ``AuthorizationCodeVerifier/challenge`` value to pass into ``authorize(with:_:)`` and
    ///  a ``AuthorizationCodeVerifier/verifier`` value to pass into ``getToken(application:code:codeVerifier:redirectURI:_:)``.
    private(set) public lazy var authorizationCodeVerifier: AuthorizationCodeVerifier = {
        storage.withLock { raw in
            var verifier = Discord_AuthorizationCodeVerifier()
            raw.createAuthorizationCodeVerifier(&verifier)
            return AuthorizationCodeVerifier(takingOwnership: verifier)
        }
    }()
    

    // MARK: Methods

    //    @available(*, deprecated, renamed: "currentUser", message: "This will be removed in a future version.")
    //    public func _currentUser() -> UserHandle {
    //        storage.withLock { raw in
    //            var handle = Discord_UserHandle()
    //            Discord_Client_GetCurrentUser(&raw, &handle)
    //            return UserHandle(takingOwnership: handle)
    //        }
    //    }

    public func setHttpRequestTimeout(milliseconds time: Int32) {
        usingLock { $0.setHttpRequestTimeout(time) }
    }

    /// Returns a reference to the currently active call, if any.
    public func call(for channel: UInt64) -> DiscordCall {
        storage.withLock { raw in
            var call = Discord_Call()
            _ = raw.getCall(channel, &call)
            return DiscordCall(takingOwnership: call)
        }
    }

    /// Returns a reference to all currently active calls, if any.
    public func calls() -> [DiscordCall] {
        storage.withLock { raw in
            var span = Discord_CallSpan()
            raw.getCalls(&span)
            return span.converting()
        }
    }

    /// Enables or disables AEC diagnostic recording.
    /// Used to diagnose issues with acoustic echo cancellation.
    /// The input and output waveform data will be written to the log directory.
    public func aecDump(enabled: Bool) {
        usingLock { $0.setAecDump(enabled) }
    }

    /// On mobile devices, enable speakerphone mode.
    @discardableResult
    @available(*, deprecated, message: "Calling Client.setSpeakerMode is DEPRECATED.")
    public func speakerMode(enabled: Bool) -> Bool {
        usingLock { $0.setSpeakerMode(enabled) }
    }

    /// Allows setting the priority of various SDK threads.
    /// ### Available Threads
    /// - ``ClientThread/client``:
    ///   The main SDK thread responsible for most data processing and coordination.
    ///
    /// - ``ClientThread/network``:
    ///   Handles incoming voice data for lobby calls.
    ///
    /// - ``ClientThread/voice``:
    ///   Runs the voice engine and processes all audio data.
    ///
    /// - Parameters:
    ///   - thread: The SDK thread whose priority you want to adjust.
    ///   - priority: The priority value to assign. Higher values typically indicate
    ///               higher scheduling precedence.
    public func setPriority(thread: ClientThread, priority: Int32) {
        usingLock { $0.setThreadPriority(thread.discordValue, priority) }
    }

    /// On iOS devices, show the system audio route picker.
    @discardableResult
    @available(iOS 15.1, *)
    public func showAudioRoutePicker() -> Bool {
        usingLock { $0.showAudioRoutePicker() }
    }

    /// Starts or joins a call in the lobby specified by `id` (for a lobby, simply
    /// pass in the lobby ID).
    ///
    /// On iOS, your application is responsible for enabling the appropriate background
    /// audio mode in your Info.plist. VoiceBuildPostProcessor in the sample demonstrates
    /// how to do this automatically in a Unity build process.
    ///
    /// On macOS, you should set the NSMicrophoneUsageDescription key in your Info.plist.
    ///
    /// Returns `nil` if the user is already in the given voice channel.
    ///
    /// - Parameter id: The channel or lobby identifier to start or join a call in.
    /// - Returns: A ``DiscordCall`` instance if the call was successfully started or joined,
    ///  		   otherwise `nil` if already inside the voice channel.
    public func call(lobby id: UInt64) -> DiscordCall? {
        storage.withLock { raw -> DiscordCall? in
            var call = Discord_Call()
            guard Discord_Client_StartCall(&raw, id, &call) else { return nil }
            return DiscordCall(takingOwnership: call)
        }
    }

    /// This will abort the authorize flow if it is in progress and tear down any associated
    ///
    /// - important: This *will not* close authorization windows presented to the user.
    public func abortAuthorize() {
        usingLock { $0.abortAuthorize() }
    }

    /// This function is used to abort/cleanup the device authorization flow.
    public func abortGetDeviceToken() {
        usingLock { $0.abortGetTokenFromDevice() }
    }

    /// This function is used to hide the device authorization screen and is used for the
    /// case where the user is on a limited input device, such as a console or smart TV. This
    /// function should be used in conjunction with a backend server to handle the device
    /// authorization flow. For a public client, you can use ``abortGetDeviceToken()`` instead.
    public func closeAuthorizationDeviceScreen() {
        usingLock { $0.closeAuthorizeDeviceScreen() }
    }

    /// This function is used to show the device authorization screen and is used for the
    /// case where the user is on a limited input device, such as a console or smart TV. This
    /// function should be used in conjunction with a backend server to handle the device
    /// authorization flow. For a public client, you can use ``getTokenFromDevice(args:_:)`` instead.
    public func openAuthorizationDeviceScreen(id: UInt64, code: String) {
        code.withDiscordString { str in
            usingLock(Discord_Client_OpenAuthorizeDeviceScreen, id, str)
        }
    }

    /// Some functions don't work for provisional accounts, and require the user
    /// merge their account into a full Discord account before proceeding. This
    /// callback is invoked when an account merge must take place before
    /// proceeding. The developer is responsible for initiating the account merge,
    /// and then calling ``provisionalUserMergeCompleted(_:)`` to signal to the SDK that
    /// the pending operation can continue with the new account.
    public func provisionalUserMergeCompleted(_ success: Bool) {
        usingLock { $0.provisionalUserMergeCompleted(success) }
    }

    /// Stops listening for the `AUTHORIZE_REQUEST` event and removes the registered callback
    ///
    /// This function is tied to upcoming Discord client functionality experiments that will be
    /// rolled out to a percentage of Discord users over time. More documentation and implementation
	/// details to come as the client experiments run.
    public func removeAuthorizeRequestCallback() {
        usingLock { $0.removeAuthorizeRequestCallback() }
    }

    /// When users are linking their account with Discord, which involves an OAuth2 flow,
    /// the SDK can streamline it by using Discord's overlay so the interaction happens entirely
    /// in-game. If your game's main window is not the same process as the one running the
    /// integration you may need to set the window PID using this method. It defaults to the current
    /// pid.
    public func setGameWindowPID(to pid: pid_t) {
        usingLock { $0.setGameWindowPid(pid) }
    }
    

    /// Returns true if the given message is able to be viewed in a Discord client.
    ///
    /// Not all chat messages are replicated to Discord. For example lobby chat and some DMs
    /// are ephemeral and not persisted on Discord so cannot be opened. This function checks those
    /// conditions and makes sure the message is viewable in Discord.
    public func canOpenMessageInDiscord(id: UInt64) -> Bool {
        usingLock { $0.canOpenMessageInDiscord(id) }
    }

    /// Returns a reference to the Discord channel object for the given ID.
    ///
    /// All messages in Discord are sent in a channel, so the most common use for this will be
    /// to look up the channel a message was sent in.
    /// For convience this API will also work with lobbies, so the three possible return values
    /// for the SDK are a DM, an Ephemeral DM, and a Lobby.
    public func channelHandle(for id: UInt64) -> ChannelHandle? {
        storage.withLock { raw -> ChannelHandle? in
            var handle = Discord_ChannelHandle()
            guard raw.getChannelHandle(id, &handle) else { return nil }
            return ChannelHandle(takingOwnership: handle)
        }
    }

    /// Returns a reference to the Discord message object for the given ID.
    ///
    /// The SDK keeps the 25 most recent messages in each channel in memory.
    /// Messages sent before the SDK was started cannot be accessed with this.
    public func messageHandle(for msgId: UInt64) -> MessageHandle? {
        storage.withLock { raw -> MessageHandle? in
            var handle = Discord_MessageHandle()
            guard raw.getMessageHandle(msgId, &handle) else { return nil }
            return MessageHandle(takingOwnership: handle)
        }
    }

    /// Returns the Discord lobby object for the given ID.
    public func lobbyHandle(for id: UInt64) -> LobbyHandle? {
        storage.withLock { raw -> LobbyHandle? in
            var handle = Discord_LobbyHandle()
            guard raw.getLobbyHandle(id, &handle) else { return nil }
            return LobbyHandle(takingOwnership: handle)
        }
    }

    public func relationshipHandle(for id: UInt64) -> RelationshipHandle {
        storage.withLock { raw in
            var handle = Discord_RelationshipHandle()
            raw.getRelationshipHandle(id, &handle)
            return RelationshipHandle(takingOwnership: handle)
        }
    }

    /// Sets whether chat messages are currently being shown in the game.
    ///
    /// If the user has the Discord desktop application open on the same machine as the game,
    /// they will hear notifications from the Discord application, even though they can see
    /// those messages in game. To avoid duplicate notifications, you can call this function
    /// whenever the chat is shown or hidden to suppress those notifications.
    ///
    /// Keep in mind that if the game stops showing chat for a period of time, or loses focus
    /// because the user switches to a different application, it is important to call this
    /// function again so that notifications are re-enabled in Discord during that time.
    ///
    /// - Parameter show: A Boolean value indicating whether chat is currently visible in the game.
    public func showChat(_ show: Bool) {
        usingLock { $0.setShowingChat(show) }
    }

    /// Asynchronously connects the client to Discord.
    ///
    /// If the client is currently disconnecting, this function will wait for the disconnect
    /// to complete before reconnecting. You should use ``DiscordClient/StatusChangedCallback``
    /// and ``DiscordClient/status`` to receive updates on the client status. The client is only
    /// safe to use once the status changes to ``ClientStatus/ready``.
    public func connect() {
        usingLock { $0.connect() }
    }

    /// Asynchronously disconnects the client.
    ///
    /// You can use ``DiscordClient/StatusChangedCallback`` and ``ClientStatus`` to receive
    /// updates on the client status. The client is fully disconnected once the status
    /// changes to ``ClientStatus/disconnected``.
    public func disconnect() {
        usingLock { $0.disconnect() }
    }

    /// Causes logs generated by the SDK to be written to disk in the specified directory.
    ///
    /// This function excludes most logs related to voice and WebRTC activity, as those tend to be
    /// significantly more verbose and may require a different logging level. Instead, it includes
    /// logs for systems such as lobbies, relationships, presence, and authentication.
    ///
    /// An empty path defaults to logging alongside the client library. A severity of
    /// `LoggingSeverity.none` disables logging to a file (this is also the default).
    /// Logs are written to a file named `discord.log` in the specified directory,
    /// overwriting any existing file.
    ///
    /// It is strongly recommended to invoke this function immediately after constructing the Client
    /// object.
    ///
    /// - Parameters:
    ///   - path: The directory where logs should be written.
    ///   - severity: The minimum logging severity to include in the file.
    /// - Returns: `true` if the log file was successfully opened, otherwise `false`.
    public func setLogDir(to path: String, for severity: LoggingSeverity) -> Bool {
        path.withDiscordString { str in
            usingLock { $0.setLogDir(str, severity.discordValue) }
        }
    }

    public func setVoiceLogDir(to path: String, for severity: LoggingSeverity) {
        path.withDiscordString { str in
            usingLock { $0.setVoiceLogDir(str, severity.discordValue) }
        }
    }
    /// Clears the rich presence for the current user.
    public func clearRichPresence() {
        usingLock { $0.clearRichPresence() }
    }

    @discardableResult
    public func registerLaunchCommand(id: UInt64, command: String) -> Bool {
        command.withDiscordString { str in
            usingLock { $0.registerLaunchCommand(id, str) }
        }
    }

    @discardableResult
    public func registerLaunchSteamApplication(id: UInt64, steamId: UInt32) -> Bool {
        usingLock { $0.registerLaunchSteamApplication(id, steamId) }
    }

    /// Returns a list of relationships that belong to the specified relationship group type.
    /// Relationships are logically partitioned into groups based on online status and game
    /// activity:
    /// - ``RelationshipGroupType/onlinePlayingGame``: Users who are online and currently playing the game
    /// - ``RelationshipGroupType/onlineElsewhere``: Users who are online but not playing the game (users who have played the game before are sorted to the top)
    /// - ``RelationshipGroupType/offline``: Users who are offline
    public func relationships(
        in group: RelationshipGroupType
    ) -> [RelationshipHandle] {
        storage.withLock { raw in
            var span = Discord_RelationshipHandleSpan()
            raw.getRelationshipsByGroup(group.discordValue, &span)
            return span.converting()
        }
    }

    public func searchFriends(
        matching username: String
    ) -> [UserHandle] {
        username.withDiscordString { str in
            storage.withLock { raw in
                var span = Discord_UserHandleSpan()
                raw.searchFriendsByUsername(str, &span)
                return span.converting()
            }
        }
    }

    // MARK: Helper
    func setCallback<T>(_ cb: T, to kp: WritableKeyPath<PersistentCallbacks, CallbackBox<T>>) -> UnsafeMutableRawPointer {
        persistent[keyPath: kp].callback = cb
        return persistent[keyPath: kp].unretainedOpaqueValue()
    }
}

extension DiscordClient {
    struct PersistentCallbacks: Sendable {
        // Audio
        var deviceChange = CallbackBox<AudioDeviceChangedCallback>()
        var noAudioInput = CallbackBox<NoAudioInputCallback>()
        var voiceParticipant = CallbackBox<VoiceParticipantChangedCallback>()

        // Messaging
        var messageCreated = CallbackBox<MessageCreatedCallback>()
        var messageDeleted = CallbackBox<MessageDeletedCallback>()
        var messageUpdated = CallbackBox<MessageUpdatedCallback>()

        // Lobbies
        var lobbyCreated = CallbackBox<LobbyCreatedCallback>()
        var lobbyDeleted = CallbackBox<LobbyDeletedCallback>()
        var lobbyUpdated = CallbackBox<LobbyUpdatedCallback>()
        var lobbyMemberAdded = CallbackBox<LobbyMemberAddedCallback>()
        var lobbyMemberRemoved = CallbackBox<LobbyMemberRemovedCallback>()
        var lobbyMemberUpdated = CallbackBox<LobbyMemberUpdatedCallback>()

        // Activity
        var activityInviteCreated = CallbackBox<ActivityInviteCallback>()
        var activityInviteUpdated = CallbackBox<ActivityInviteCallback>()
        var activityJoin = CallbackBox<ActivityJoinCallback>()
        var activityJoinWithApp = CallbackBox<ActivityJoinWithApplicationCallback>()

        // Relationships / Users
        var relationshipCreated = CallbackBox<RelationshipCreatedCallback>()
        var relationshipDeleted = CallbackBox<RelationshipDeletedCallback>()
        var relationshipGroups = CallbackBox<RelationshipGroupsUpdatedCallback>()
        var userUpdated = CallbackBox<UserUpdatedCallback>()

        // Auth / Connection
        var statusChanged = CallbackBox<StatusChangedCallback>()
        var tokenExpiration = CallbackBox<TokenExpirationCallback>()
        var authorizeRequest = CallbackBox<AuthorizeRequestCallback>()
        var authorizeDeviceClosed = CallbackBox<AuthorizeDeviceScreenClosedCallback>()
        var log = CallbackBox<LogCallback>()
        var voiceLog = CallbackBox<LogCallback>()
    }
}

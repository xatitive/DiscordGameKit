//
//  DiscordEnums.swift
//  DiscordCommon
//
//  Created by Christian Norton on 3/20/26.
//

/// ActivityActionTypes represents the type of invite being sent to a user.
///
/// There are essentially two types of invites:
/// 1: A user with an existing activity party can invite another user to join that existing party
/// 2: A user can request to join the existing activity party of another user
///
/// - seealso: https://discord.com/developers/docs/rich-presence/overview
@nonexhaustive
public enum ActivityActionType: UInt32, Sendable {
    case invalid = 0
    case join = 1
    case joinRequest = 5
}

/// Allows your game to control the privacy of the party the user is in.
@nonexhaustive
public enum ActivityPartyPrivacy: UInt32, Sendable {
    
    /// The party is private (or unknown), which means that the user is in a party but it is
    /// not
    /// joinable without sending a request to join the party.
    ///
    /// This is the default value. You will also receive this value when receiving other users'
    /// activities as the party privacy for other users is not exposed.
    case `private` = 0
    
    /// The party is public, which means that the user is in a party which *could* be
    /// joinable by
    /// either friends or mutual voice participants without sending a request to join the party.
    /// This depends on a user's desired Discord account privacy settings.
    case `public` = 1
}

/// Discord RichPresence supports multiple types of activities that a user can be doing.
///
/// For the SDK, the only activity type that is really relevant is `Playing`.
/// The others are provided for completeness.
///
/// See https://discord.com/developers/docs/rich-presence/overview for more information.
@nonexhaustive
public enum ActivityType: UInt32, Sendable {
    case playing = 0
    case streaming = 1
    case listening = 2
    case watching = 3
    case customStatus = 4
    case competing = 5
    case hangStatus = 6
}

/// Controls which Discord RichPresence field is displayed in the user's status.
///
/// See https://discord.com/developers/docs/rich-presence/overview for more information.
@nonexhaustive
public enum StatusDisplayType: UInt32, Sendable {
    case name = 0
    case state = 1
    case details = 2
}

/// Represents the type of platforms that an activity invite can be accepted on.
public struct ActivityGamePlatform: Sendable, RawRepresentable {
    public static let desktop   = ActivityGamePlatform(rawValue: 1)
    public static let xbox      = ActivityGamePlatform(rawValue: 2)
    public static let samsung   = ActivityGamePlatform(rawValue: 4)
    public static let iOS       = ActivityGamePlatform(rawValue: 8)
    public static let android   = ActivityGamePlatform(rawValue: 16)
    public static let embedded  = ActivityGamePlatform(rawValue: 32)
    public static let ps4       = ActivityGamePlatform(rawValue: 64)
    public static let ps5       = ActivityGamePlatform(rawValue: 128)
    
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
}

/// Enum representing various types of errors the SDK returns.
@nonexhaustive
public enum ErrorType: UInt32, Sendable, Error {
    
    /// No error, the operation was successful.
    case none = 0
    
    /// The user is offline or there was some network issue that prevented an underlying
    /// HTTP call from succeeding.
    case networkError = 1
    
    /// An HTTP call was made to Discord's servers but a non success HTTP status code was
    /// returned.
    /// In some cases this may be retryable, and if so ``ClientResult/isRetryable`` will be true.
    /// In most cases though the failure is due to a validation or permissions error, and the
    /// request is not retryable. ``ClientResult/error`` and ``ClientResult/errorCode`` will have more
    /// information.
    case httpError = 2
    
    /// An operation such as sending a friend request or joining a lobby was attempted but
    /// the
    /// Client is not yet ready. Wait for ``DiscordClient/status`` to change to ``ClientStatus/ready`` before
    /// trying again.
    ///
    /// Also be sure to call ``DiscordClient/connect()`` to begin the process of connecting to Discord's
    /// servers, otherwise
    /// the Client will never become ready.
    case clientNotReady = 3
    
    /// An operation was temporarily disabled for stability reasons.
    case disabled = 4
    
    /// The Client has been destroyed and so this operation cannot complete.
    case clientDestroyed = 5
    
    /// Used when an SDK method is called but the inputs don't pass local validation. For
    /// example
    /// if one attempts to accept a friend request when there is no pending friend request for that
    /// user,
    /// this ErrorType would be used.
    ///
    /// The specific validation error will be included in the `error` field, and no other
    /// ClientResult fields will be set.
    case validationError = 6
    
    /// The user or developer aborted an operation, such as an authorization flow.
    case aborted = 7
    
    /// An authorization function failed, but not necessarily as the result of an HTTP call
    /// that
    /// returned an error.
    case authorizationFailed = 8
    
    /// An RPC call was made to Discord's desktop application, but it returned a non-success
    /// result.
    /// The error and errorCode fields should both be set with more information.
    case rpcError = 9
    
}

/// Enum that represents the various HTTP status codes that can be returned.
///
/// You can read more about these at: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
/// For convenience, we have defined a couple of enum values that are non-standard HTTP codes to
/// represent certain types of errors.
@nonexhaustive
public enum HttpStatusCode: UInt32, Sendable {
    case none = 0
    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    case earlyHints = 103
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInfo = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case imUsed = 209
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case temporaryRedirect = 307
    case permanentRedirect = 308
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case tooEarly = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthorizationRequired = 511
}

/// Represents the crypto method used to generate a code challenge.
///
/// The only method used by the SDK is sha256.
@nonexhaustive
public enum AuthenticationCodeChallengeMethod: UInt32, Sendable {
    case s256 = 0
}

/// Represents the type of integration the app will be installed as.
@nonexhaustive
public enum IntegrationType: UInt32, Sendable {
    case guildInstall = 0
    case userInstall = 1
}

/// Enum that represents the various channel types on Discord.
///
/// For more information see: https://discord.com/developers/docs/resources/channel
@nonexhaustive
public enum ChannelType: UInt32, Sendable {
    case guildText = 0
    case dm = 1
    case guildVoice = 2
    case groupDm = 3
    case guildCategory = 4
    case guildNews = 5
    case guildStore = 6
    case guildNewsThread = 10
    case guildPublicThread = 11
    case guildPrivateThread = 12
    case guildStageVoice = 13
    case guildDirectory = 14
    case guildForum = 15
    case guildMedia = 16
    case lobby = 17
    case ephemeralDm = 18
}

/// Represents the type of additional content contained in a message.
@nonexhaustive
public enum AdditionalContentType: UInt32, Sendable {
    case other = 0
    case attachment = 1
    case poll = 2
    case voiceMessage = 3
    case thread = 4
    case embed = 5
    case sticker = 6
}

/// The Discord Voice audio system to use.
@nonexhaustive
public enum AudioSystem: UInt32, Sendable {
    case standard = 0
    case game = 1
}

/// Enum that represents any network errors with the Call.
@nonexhaustive
public enum CallError: UInt32, Sendable, Error {
    case none = 0
    case signalingConnectionFailed = 1
    case signalingUnexpectedClose = 2
    case voiceConnectionFailed = 3
    case joinTimeout = 4
    case forbidden = 5
}

/// Represents whether a voice call is using push to talk or auto voice detection
@nonexhaustive
public enum AudioModeType: UInt32, Sendable {
    case uninitialized = 0
    case vad = 1
    case ptt = 2
}

/// Enum that respresents the state of the Call's network connection.
@nonexhaustive
public enum CallStatus: UInt32, Sendable {
    case disconnected = 0
    case joining = 1
    case connecting = 2
    case signalingConnected = 3
    case connected = 4
    case reconnecting = 5
    case disconnecting = 6
}

/// Enum that represents the possible types of relationships that can exist between two users
@nonexhaustive
public enum RelationshipType: UInt32, Sendable {
    
    /// The user has no relationship with the other user.
    case none = 0
    
    /// The user is friends with the other user.
    case friend = 1
    
    /// The current user has blocked the target user, and so certain actions
    /// such as sending messages between these users will not work.
    case blocked = 2
    
    /// The current user has received a friend request from the target user, but it is not yet accepted.
    case pendingIncoming = 3
    
    /// The current user has sent a friend request to the target user, but it is not yet accepted.
    case pendingOutgoing = 4
    
    /// The Implicit type is documented for visibility, but should be unused in the SDK.
    case implicit = 5
    
    /// The Suggestion type is documented for visibility, but should be unused in the SDK.
    case suggestion = 6
}

/// The type of external identity provider.
@nonexhaustive
public enum ExternalIdentityProviderType: UInt32, Sendable {
    case oidc = 0
    case epicOnlineServices = 1
    case steam = 2
    case unity = 3
    case discordBot = 4
    case none = 5
    case unknown = 6
}

/// The desired type of avatar url to generate for a User.
@nonexhaustive
public enum AvatarType: UInt32, Sendable {
    case gif = 0
    case webp = 1
    case png = 2
    case jpeg = 3
}

/// Enum that specifies the various online statuses for a user.
///
/// Generally a user is online or offline, but in Discord users are able to further customize their
/// status such as turning on "Do not Disturb" mode or "Dnd" to silence notifications.
@nonexhaustive
public enum StatusType: UInt32, Sendable {
    case online = 0
    case offline = 1
    case blocked = 2
    case idle = 3
    case dnd = 4
    case invisible = 5
    case streaming = 6
    case unknown = 7
}

/// Enum that represents various informational disclosures that Discord may make to users, so
/// that the game can identity them and customize their rendering as desired.
///
/// See MessageHandle for more details.
@nonexhaustive
public enum DisclosureType: UInt32, Sendable {
    
    /// This disclosure type happens the first time a user sends a message in game,
    /// and that message will be able to be viewed on Discord,
    /// so the user knows their content is being copied out of the game.
    case messageDataVisibleOnDiscord = 3
}

/// Represents an error state for the socket connection that the Discord SDK maintains
/// with the Discord backend.
///
/// Generic network failures will use the ``connectionFailed`` and ``connectionCanceled``
/// enum values. Other errors such as if the user's auth token is invalid or out of
/// date will be ``unexpectedClose`` and you should look at the other Error fields for the specific
/// details.
@nonexhaustive
public enum ClientError: UInt32, Sendable, Error {
    case none = 0
    case connectionFailed = 1
    case unexpectedClose = 2
    case connectionCanceled = 3
}

/// This enum refers to the status of the internal websocket the SDK uses to communicate
/// with Discord There are ~2 phases for "launching" the client:
/// 1. The socket has to connect to Discord and exchange an auth token. This is indicated by the
/// ``connecting`` and ``connected`` values.
/// 2. The socket has to receive an initial payload of data that describes the current user,
/// what lobbies they are in, who their friends are, etc. This is the ``ready`` status.
/// Many Client functions will not work until the status changes to ``ready``, such as
/// ``DiscordClient/currentUser``.
///
/// ``ClientStatus/ready`` is the one you want to wait for!
///
/// Additionally, sometimes the socket will be disconnected, such as through temporary network
/// blips. But it will try to automatically reconnect, as indicated by the ``reconnecting``
/// status.
@nonexhaustive
public enum ClientStatus: UInt32, Sendable {
    case disconnected = 0
    case connecting = 1
    case connected = 2
    case ready = 3
    case reconnecting = 4
    case disconnecting = 5
    case httpWait = 6
}

/// Represents the type of thread to control thread priority on.
@nonexhaustive
public enum ClientThread: UInt32, Sendable {
    case client = 0
    case voice = 1
    case network = 2
}

/// Represents the type of auth token used by the SDK, either the normal tokens produced by
/// the Discord desktop app, or an oauth2 bearer token. Only the latter can be used by the SDK.
@nonexhaustive
public enum AuthorizationTokenType: UInt32, Sendable {
    case user = 0
    case bearer = 1
}

/// Represents the various identity providers that can be used to authenticate a provisional
/// account user for public clients.
@nonexhaustive
public enum AuthenticationExternalAuthType: UInt32, Sendable {
    case oidc = 0
    case epicOnlineServicesAccessToken = 1
    case epicOnlineServicesIdToken = 2
    case steamSessionTicket = 3
    case unityServicesIdToken = 4
    case discordBotIssuedAccessToken = 5
    case appleIdToken = 6
    case playStationNetworkIdToken = 7
}

/// Enum that represents the various log levels supported by the SDK.
@nonexhaustive
public enum LoggingSeverity: UInt32, Sendable {
    case verbose = 1
    case info = 2
    case warning = 3
    case error = 4
    case none = 5
}

/// Enum that represents the logical groups of relationships based on online status and game activity
@nonexhaustive
public enum RelationshipGroupType: UInt32, Sendable {
    
    /// Users who are online and currently playing the game/
    case onlinePlayingGame = 0
    
    /// Users who are online but not playing the game
    case onlineElsewhere = 1
    
    /// Users who are offline
    case offline = 2
}

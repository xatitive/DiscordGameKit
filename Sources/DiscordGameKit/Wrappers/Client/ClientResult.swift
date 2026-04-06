//
//  ClientResult.swift
//  dhinaSwifting
//
//  Created by Christian Norton on 3/29/26.
//

@_implementationOnly import discord_partner_sdk

/// Struct that stores information about the result of an SDK function call.
///
/// Functions can fail for a few reasons including:
/// - The Client is not yet ready and able to perform the action.
/// - The inputs passed to the function are invalid.
/// - The function makes an API call to Discord's backend which returns an error.
/// - The user is offline.
///
/// The ``ClientResult/errorType`` field is used to to distinguish between the above types of failures
public struct ClientResult: DiscordObject, CustomStringConvertible, Sendable, Error {
    var storage: DiscordStorage<Discord_ClientResult>
    init(storage: DiscordStorage<Discord_ClientResult>) {
        self.storage = storage
    }
    
    /// The type of error that occurred.
    ///
    /// See ``ErrorType`` for more information.
    public var errorType: ErrorType {
        get { usingLock(Discord_ClientResult_Type).swiftValue }
        set {
            ensureUnique()
            usingLock(Discord_ClientResult_SetType, newValue.discordValue)
        }
    }
    
    /// The HTTP status code of the API call.
    ///
    /// This will only be set if the type of error is``ErrorType/httpError``.
    public var status: HttpStatusCode {
        get { usingLock(Discord_ClientResult_Status).swiftValue }
        set {
            ensureUnique()
            usingLock(Discord_ClientResult_SetStatus, newValue.discordValue)
        }
    }
    
    /// A description of the error that occurred.
    public var error: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_ClientResult_Error(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock(Discord_ClientResult_SetError, str)
            }
        }
    }
    
    /// The full HTTP response body, which will usually be a JSON string.
    ///
    /// The error format here is a bit more complicated because Discord's API tries to
    /// make it clear which field from the request is causing the error. Documentation on the format
    /// of these errors is here: https://discord.com/developers/docs/reference#error-messages
    ///
    /// This will only be set if the type of error is  ``ErrorType/httpError``.
    public var responseBody: String {
        get {
            storage.withLock { raw in
                var ds = Discord_String()
                Discord_ClientResult_ResponseBody(&raw, &ds)
                return String(discordOwned: ds)
            }
        }
        set {
            ensureUnique()
            newValue.withDiscordString { str in
                usingLock(Discord_ClientResult_SetResponseBody, str)
            }
        }
    }
    
    /// A more detailed error code for this failure. Currently the only use of this is when an API request is made to Discord's backend and that fails with a specific error, that error will be included in this field.
    ///
    /// Many of these error codes are documented at: https://discord.com/developers/docs/topics/opcodes-and-status-codes#json
    /// This will only be set if the type of error is ``ErrorType/httpError``.
    public var errorCode: Int32 {
        get { usingLock(Discord_ClientResult_ErrorCode) }
        set {
            ensureUnique()
            usingLock(Discord_ClientResult_SetErrorCode, newValue)
        }
    }
    
    /// Equivalent to `errorType == ErrorType/none`
    public var isSuccessful: Bool {
        get { usingLock(Discord_ClientResult_Successful) }
        set {
            ensureUnique()
            usingLock(Discord_ClientResult_SetSuccessful, newValue)
        }
    }

    /// Indicates if, although an API request failed, it is safe and recommended to retry it.
    public var isRetryable: Bool {
        get { usingLock(Discord_ClientResult_Retryable) }
        set {
            ensureUnique()
            usingLock(Discord_ClientResult_SetRetryable, newValue)
        }
    }

    /// When a user is being rate limited by Discord (and so status == 429), this field should be set and is the number of seconds to wait before trying again.
    public var retryAfter: Float {
        get { usingLock(Discord_ClientResult_RetryAfter) }
        set {
            ensureUnique()
            usingLock(Discord_ClientResult_SetRetryAfter, newValue)
        }
    }
    
    /// Error message if any of the ClientResult.
    public var description: String {
        storage.withLock { raw in
            var ds = Discord_String()
            Discord_ClientResult_ToString(&raw, &ds)
            return String(discordOwned: ds)
        }
    }
}

extension Discord_ClientResult {
    var successful: Bool {
        mutating get {
            Discord_ClientResult_Successful(&self)
        }
    }
}

extension UnsafeMutablePointer where Pointee == Discord_ClientResult {
    var successful: Bool {
        get {
            pointee.successful
        }
    }
}

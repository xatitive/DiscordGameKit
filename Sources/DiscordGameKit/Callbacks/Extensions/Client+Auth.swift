//
//  Client+Auth.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

extension DiscordClient {
    
    /// Initiates an OAuth2 flow for a user to "sign in with Discord". This flow is intended
    /// for desktop and mobile devices. If you are implementing for the console, leverage the device
    /// auth flow instead - ``getTokenFromDevice(args:_:)`` or ``openAuthorizationDeviceScreen(id:code:)``.
    ///
    /// ## Overview
    /// If you're not familiar with OAuth2, some basic background: At a high level the goal of
    /// OAuth2 is to allow a user to connect two applications together and share data between them.
    /// In this case, allowing a game to access some of their Discord data. The high level flow is:
    /// - This function, authorize, is invoked to start the OAuth2 process, and the user is sent to
    ///   Discord.
    /// - On Discord, the user sees a prompt to authorize the connection, and that prompt explains
    ///   what data and functionality the game is requesting.
    /// - Once the user approves the connection, they are redirected back to your application with a
    ///   secret code.
    /// - You can then exchange that secret code to get back an access token which can be used to
    ///   authenticate with the SDK.
    ///
    /// ## Public vs Confidential Clients
    /// Normal OAuth2 requires a backend server to handle exchanging the "code" for a "token" (the
    /// last step mentioned above). Not all games have backend servers or their own identity system
    /// though, and for early testing of the SDK that can take some time to set up.
    ///
    /// If desired, you can instead change your Discord application in the developer portal (on the
    /// OAuth2 tab) to be a "public" client. This will allow you to exchange the code for a token
    /// without a backend server, by using the GetToken function. You can also change this setting
    /// back once you have a backend in place later.
    ///
    /// ## Overlay
    /// To streamline the authentication process, the SDK will attempt to use the Discord overlay if
    /// it is enabled. This will allow the user to authenticate without leaving the game, enabling a
    /// more seamless experience.
    ///
    /// You should check to see if the Discord overlay works with your game before shipping. It is
    /// acceptable if it does not, as the SDK will fall back to using a browser window. Once you are
    /// ready to ship, you can work with Discord to have the overlay enabled by default for your game.
    ///
    /// If your game's main window is not the same process that the SDK is running in, you need to
    /// tell the SDK the PID of the window that the overlay should attach to by calling
    /// Client.SetGameWindowPid.
    ///
    /// ## Redirects
    /// For the authorize function to work, you must configure a redirect URL in your Discord
    /// application in the developer portal (on the OAuth2 tab).
    /// - For desktop applications, add `http://127.0.0.1/callback`.
    /// - For mobile applications, add `discord-APP_ID:/authorize/callback`.
    ///
    /// The SDK will spin up a local web server to handle OAuth2 redirects for you to streamline
    /// integration.
    ///
    /// ## Security
    /// This function accepts an args object, and two of those values are important for security:
    /// - To prevent CSRF attacks during authentication, the SDK automatically attaches a state and
    ///   validates it. You may override the state if needed, but it should remain a secure, random value.
    /// - If you are using the GetToken function, you must provide a code challenge or code verifier.
    ///   The property, ``DiscordClient/authorizationCodeVerifier``, generates both values. The
    ///   `challenge` is passed into this function, and the `verifier` is used with GetToken.
    ///
    /// ## Callbacks and Code Exchange
    /// When this flow completes, the provided callback is invoked with a "code". That code must be
    /// exchanged for an authorization token before use. Initially, you can use the GetToken function
    /// to perform this exchange. Long-term, private applications should move this logic to a server-side
    /// implementation.
    ///
    /// ## Android
    /// You must add the appropriate intent filter to your AndroidManifest.xml.
    /// AndroidBuildPostProcessor in the sample demonstrates how to do this automatically.
    ///
    /// If managing manually, include the following in your `<application>`:
    /// ```xml
    /// <activity android:name="com.discord.socialsdk.AuthenticationActivity"
    /// android:exported="true">
    ///   <intent-filter>
    ///     <action android:name="android.intent.action.VIEW" />
    ///     <category android:name="android.intent.category.DEFAULT" />
    ///     <category android:name="android.intent.category.BROWSABLE" />
    ///     <data android:scheme="discord-APP_ID" />
    ///   </intent-filter>
    /// </activity>
    /// ```
    /// Replace `APP_ID` with your application ID from the Discord developer portal.
    ///
    /// Android support for this flow requires the androidx.browser dependency (version 1.8.0).
    ///
    /// - seealso: [Discord OAuth2 Reference](https://discord.com/developers/docs/topics/oauth2)
    public func authorize(with args: AuthorizationArgs, _ body: @escaping AuthorizationCallback) {
        let cb = CallbackBox(body)
        storage.withLock { client in
            args.storage.withLock { argPtr in
                Discord_Client_Authorize(
                    &client,
                    &argPtr,
                    authorizationTrampoline,
                    freeBox,
                    cb.retainedOpaqueValue()
                )
            }
        }
    }
    
    /// Exchanges a parent application token for a child application token.
    ///
    /// This is used to obtain a token for a child application that is linked to a parent
    /// application. This is only relevant if you have applications set up in a parent/child
    /// relationship, such as when a publisher manages multiple games under the same account system.
    /// Access to this feature is currently limited.
    ///
    /// - attention: This function only works for public clients. Public clients are applications that do
    /// not have a backend server or their own user account system and instead rely on external
    /// authentication providers such as Steam or Epic.
    ///
    /// When initially testing the SDK, it is often easier to use a public client to establish a
    /// proof of concept, and later transition to a confidential client. This setting can be toggled
    /// on the OAuth2 page for your application in the [Discord Developer Portal](https://discord.com/developers/applications).
    ///
    /// - Parameters:
    ///   - token: The parent application token.
    ///   - id: The identifier of the child application.
    ///   - body: Callback invoked with the result of the token exchange.
    public func exchangeChildToken(
        parentToken token: String,
        childId id: UInt64,
        _ body: @escaping ExchangeChildTokenCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in
            usingLock(
                Discord_Client_ExchangeChildToken,
                str,
                id,
                exchangeChildTokenTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Provisional accounts are a way for users that have not signed up for Discord to still
    /// access SDK functionality. They are "placeholder" Discord accounts for the user that are
    /// owned and managed by your game. Provisional accounts exist so that your users can engage
    /// with Discord APIs and systems without the friction of creating their own Discord account.
    /// Provisional accounts and their data are unique per Discord application.
    ///
    /// This function generates a Discord access token. You pass in the "identity" of the user, and
    /// it generates a new Discord account that is tied to that identity. There are multiple ways of
    /// specifying that identity, including using Steam/Epic services, or using your own identity
    /// system.
    ///
    /// The callback function will be invoked with an access token that expires in 1 hour. Refresh
    /// tokens are not supported for provisional accounts, so that will be an empty string. You
    /// will need to call this function again to get a new access token when the old one expires.
    ///
    /// - note: When the token expires, the SDK will still continue to receive updates such as new
    /// messages sent in a lobby, and any voice calls will continue to be active. However, any new
    /// actions taken will fail, such as sending a message or adding a friend. You can obtain a new
    /// token and pass it to UpdateToken without interrupting the user's experience.
    ///
    /// It is suggested that these provisional tokens are not stored, and instead this function is
    /// invoked each time the game is launched and when tokens are about to expire. If you choose
    /// to store them, it is recommended to differentiate these provisional account tokens from
    /// "full" Discord account tokens.
    ///
    /// - attention: This function only works for public clients. Public clients are applications that do
    /// not have a backend server or their own concept of user accounts and instead rely on a
    /// separate system for authentication, such as Steam or Epic.
    ///
    /// When first testing the SDK, it can be easier to use a public client to get a proof of
    /// concept working, and later switch to a confidential client. You can toggle that setting on
    /// the OAuth2 page for your application in the [Discord Developer Portal](https://discord.com/developers/applications).
    ///
    /// - Parameters:
    ///   - id: The identifier for the user.
    ///   - authType: The external authentication type used to identify the user.
    ///   - token: The external authentication token.
    ///   - body: Callback invoked with the generated access token.
    public func getProvisionalToken(
        application id: UInt64,
        authType: AuthenticationExternalAuthType,
        token: String,
        _ body: @escaping TokenExchangeCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in
            usingLock(
                Discord_Client_GetProvisionalToken,
                id,
                authType.discordValue,
                str,
                tokenExchangeTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Generates a new access token for the current user from a refresh token.
    ///
    /// Once this is called, the old access and refresh tokens are both invalidated and cannot be
    /// used again. The callback function will be invoked with a new access and refresh token. See
    /// GetToken for more details.
    ///
    /// - note: This function only works for public clients. Public clients are ones that do not have
    /// a backend server or their own concept of user accounts and simply rely on a separate system
    /// for authentication like Steam/Epic.
    ///
    /// When first testing the SDK, it can be a lot easier to use a public client to get a proof of
    /// concept going, and change it to a confidential client later. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal,
    /// https://discord.com/developers/applications
    public func refreshToken(
        application id: UInt64,
        token: String,
        _ body: @escaping TokenExchangeCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in
            usingLock(
                Discord_Client_RefreshToken,
                id,
                str,
                tokenExchangeTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Exchanges an authorization code returned from the authorize function
    /// for an access token which can be used to authenticate with the SDK.
    ///
    /// The callback function will be invoked with two tokens:
    /// - An access token which can be used to authenticate with the SDK, but expires after 7 days.
    /// - A refresh token, which cannot be used to authenticate, but can be used to obtain a new
    ///   access token later. Refresh tokens do not currently expire.
    ///
    /// The callback will also include when the access token expires in seconds.
    /// You should store this value and refresh the token when it gets close to expiring
    /// (for example, if the user launches the game and the token expires within 24 hours,
    /// it would be appropriate to refresh it).
    ///
    /// - seealso: [Discord OAuth2 Reference](https://discord.com/developers/docs/topics/oauth2).
    ///
    /// - attention: This function only works for public clients. Public clients are applications that
    /// do not have a backend server or their own concept of user accounts and instead rely on
    /// a separate system for authentication, such as Steam or Epic.
    ///
    /// When first testing the SDK, it can be easier to use a public client to establish a proof
    /// of concept, and later transition to a confidential client. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal.
    ///
    /// - Parameters:
    ///   - code: The authorization code returned from authorize.
    ///   - body: Callback invoked with the access token, refresh token, and expiration information.
    public func getToken(
        application id: UInt64,
        code: String,
        codeVerifier: String,
        redirectUri: String,
        _ body: @escaping TokenExchangeCallback
    ) {
        let cb = CallbackBox(body)
        code.withDiscordString { dCode in codeVerifier.withDiscordString { dVerifier in redirectUri.withDiscordString { dUri in
            usingLock(
                Discord_Client_GetToken,
                id,
                dCode,
                dVerifier,
                dUri,
                tokenExchangeTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }}}
    }
    
    /// This function is a combination of ``authorize(with:_:)`` and ``getToken(application:code:codeVerifier:redirectUri:_:)``, but is used
    /// for the case where the user is on a limited input device, such as a console or smart TV.
    ///
    /// The callback function will be invoked with two tokens:
    /// - An access token which can be used to authenticate with the SDK, but expires after 7 days.
    /// - A refresh token, which cannot be used to authenticate, but can be used to get a new access
    /// token later. Refresh tokens do not currently expire.
    ///
    /// It will also include when the access token expires in seconds.
    /// You will want to store this value as well and refresh the token when it gets close to
    /// expiring (for example if the user launches the game and the token expires within 24 hours,
    /// it would be good to refresh it).
    ///
    /// For more information see https://discord.com/developers/docs/topics/oauth2
    ///
    /// NOTE: This function only works for public clients. Public clients are ones that do not have
    /// a backend server or their own concept of user accounts and simply rely on a separate system
    /// for authentication like Steam/Epic. If you have a backend server for auth, you can use
    /// ``openAuthorizationDeviceScreen(id:code:)`` and ``closeAuthorizationDeviceScreen()`` to show/hide the UI
    /// for the device auth flow.
    ///
    /// When first testing the SDK, it can be a lot easier to use a public client to get a proof of
    /// concept going, and change it to a confidential client later. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal,
    public func getTokenFromDevice(args: DeviceAuthorizationArgs, _ body: @escaping TokenExchangeCallback) {
        let cb = CallbackBox(body)
        storage.withLock { client in
            args.storage.withLock { argPtr in
                Discord_Client_GetTokenFromDevice(
                    &client,
                    &argPtr,
                    tokenExchangeTrampoline,
                    freeBox,
                    cb.retainedOpaqueValue()
                )
            }
        }
    }
    
    /// This function is a combination of ``authorize(with:_:)`` and
    /// ``getTokenFromProvisionalMerge(application:code:verifier:redirectUri:authType:token:_:)``,
    /// but is used for the case where the user is on a limited input device, such as a console or smart TV.
    ///
    /// This function should be used whenever a user with a provisional account wants to link to an
    /// existing Discord account or "upgrade" their provisional account into a "full" Discord
    /// account.
    ///
    /// In this case, data from the provisional account should be "migrated" to the Discord
    /// account, a process we call "account merging". Specifically relationships, DMs, and lobby
    /// memberships are transferred to the Discord account.
    ///
    /// The provisional account will be deleted once this merging process completes. If the user
    /// later unlinks, then a new provisional account with a new unique ID is created.
    ///
    /// The account merging process starts the same as the normal login flow, by invoking the
    /// ``getTokenFromDevice(args:_:)``. But instead of calling ``getTokenFromDevice(args:_:)``, call this function and pass
    /// in the provisional user's identity as well.
    ///
    /// The Discord backend can then find both the provisional account with that identity and the
    /// new Discord account and merge any data as necessary.
    ///
    /// See the documentation for ``getTokenFromDevice(args:_:)`` for more details on the callback. Note that the
    /// callback will be invoked when the token exchange completes, but the process of merging
    /// accounts happens asynchronously so will not be complete yet.
    ///
    /// - note: This function only works for public clients. Public clients are ones that do not have
    /// a backend server or their own concept of user accounts and simply rely on a separate system
    /// for authentication like Steam/Epic. If you have a backend server for auth, you can use
    /// ``openAuthorizationDeviceScreen(id:code:)`` and ``closeAuthorizationDeviceScreen()`` to show/hide the UI
    /// for the device auth flow.
    ///
    /// When first testing the SDK, it can be a lot easier to use a public client to get a proof of
    /// concept going, and change it to a confidential client later. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal,
    /// https://discord.com/developers/applications
    public func getTokenFromDeviceProvisionalMerge(
        args: DeviceAuthorizationArgs,
        authType: AuthenticationExternalAuthType,
        token: String,
        _ body: @escaping TokenExchangeCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in  storage.withLock { client in  args.storage.withLock { argPtr in
            Discord_Client_GetTokenFromDeviceProvisionalMerge(
                &client,
                &argPtr,
                authType.discordValue,
                str,
                tokenExchangeTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }}}
    }
    
    /// This function should be used with the ``authorize(with:_:)`` function whenever a user with
    /// a provisional account wants to link to an existing Discord account or "upgrade" their
    /// provisional account into a "full" Discord account.
    ///
    /// In this case, data from the provisional account should be "migrated" to the Discord
    /// account, a process we call "account merging". Specifically relationships, DMs, and lobby
    /// memberships are transferred to the Discord account.
    ///
    /// The provisional account will be deleted once this merging process completes. If the user
    /// later unlinks, then a new provisional account with a new unique ID is created.
    ///
    /// The account merging process starts the same as the normal login flow, by invoking the
    /// Authorize method to get an authorization code back. But instead of calling ``getToken(application:code:codeVerifier:redirectUri:_:)``,
    /// call this function and pass in the provisional user's identity as well.
    ///
    /// The Discord backend can then find both the provisional account with that identity and the
    /// new Discord account and merge any data as necessary.
    ///
    /// See the documentation for ``getToken(application:code:codeVerifier:redirectUri:_:)`` for more details on the callback. Note that the callback
    /// will be invoked when the token exchange completes, but the process of merging accounts
    /// happens asynchronously so will not be complete yet.
    ///
    /// - note: This function only works for public clients. Public clients are ones that do not have
    /// a backend server or their own concept of user accounts and simply rely on a separate system
    /// for authentication like Steam/Epic.
    ///
    /// When first testing the SDK, it can be a lot easier to use a public client to get a proof of
    /// concept going, and change it to a confidential client later. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal,
    /// https://discord.com/developers/applications
    public func getTokenFromProvisionalMerge(
        application id: UInt64,
        code: String,
        verifier: String,
        redirectUri: String,
        authType: AuthenticationExternalAuthType,
        token: String,
        _ body: @escaping TokenExchangeCallback
    ) {
        let cb = CallbackBox(body)
        code.withDiscordString { dCode in  verifier.withDiscordString { dVerifier in  redirectUri.withDiscordString { dUri in  token.withDiscordString { dToken in
            
            usingLock(
                Discord_Client_GetTokenFromProvisionalMerge,
                id,
                dCode,
                dVerifier,
                dUri,
                authType.discordValue,
                dToken,
                tokenExchangeTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
            
        }}}}
    }
    
    
    
    /// Registers a callback to be invoked when a user requests to initiate the authorization flow.
    ///
    /// When you register this callback, the Discord app will show new entry points to allow users
    /// to initiate the authorization flow.
    ///
    /// This function is tied to upcoming Discord client functionality experiments that will be
    /// rolled out to a percentage of Discord users over time. More documentation and implementation
    /// details to come as the client experiments run.
    public func onAuthorizationRequest(
        _ body: @escaping AuthorizeRequestCallback
    ) {
        let ptr = setCallback(body, to: \.authorizeRequest)
        usingLock(
            Discord_Client_RegisterAuthorizeRequestCallback,
            authRequestTrampoline,
            nil,
            ptr
        )
    }
    
    /// Revoke all application access/refresh tokens associated with a user with any valid
    /// access/refresh token. This will invalidate all tokens and they cannot be used again. This
    /// is useful if you want to log the user out of the game and invalidate their session.
    ///
    /// - note: This function only works for public clients. Public clients are ones that do not have
    /// a backend server or their own concept of user accounts and simply rely on a separate system
    /// for authentication like Steam/Epic.
    ///
    /// When first testing the SDK, it can be a lot easier to use a public client to get a proof of
    /// concept going, and change it to a confidential client later. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal,
    /// https://discord.com/developers/applications
    public func revokeToken(
        application id: UInt64,
        token: String,
        _ body: @escaping RevokeTokenCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in
            usingLock(
                Discord_Client_RevokeToken,
                id,
                str,
                revokeTokenTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Sets a callback to be invoked when the device authorization screen is closed.
    public func onAuthorizeDeviceScreenClosed(_ body: @escaping AuthorizeDeviceScreenClosedCallback) {
        let ptr = setCallback(body, to: \.authorizeDeviceClosed)
        usingLock(
            Discord_Client_SetAuthorizeDeviceScreenClosedCallback,
            authDeviceScreenClosedTrampoline,
            nil,
            ptr
        )
    }
    
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
    public func onTokenExpiration(_ body: @escaping TokenExpirationCallback) {
        let ptr = setCallback(body, to: \.tokenExpiration)
        usingLock(
            Discord_Client_SetTokenExpirationCallback,
            tokenExpirationTrampoline,
            nil,
            ptr
        )
    }
    
    /// This function is used to unlink/unmerge a external identity from a Discord account.
    /// This is useful if the user wants to unlink their external identity from their Discord
    /// account and create a new provisional account for that identity. This will invalidate all
    /// access/refresh tokens for the user and they cannot be used again.
    ///
    /// This function should be used with the ``getProvisionalToken(application:authType:token:_:)`` function to get a
    /// provisional token for the newly created provisional account.
    ///
    /// - note: This function only works for public clients. Public clients are ones that do not have
    /// a backend server or their own concept of user accounts and simply rely on a separate system
    /// for authentication like Steam/Epic.
    ///
    /// When first testing the SDK, it can be a lot easier to use a public client to get a proof of
    /// concept going, and change it to a confidential client later. You can toggle that setting on
    /// the OAuth2 page for your application in the Discord developer portal,
    /// https://discord.com/developers/applications
    public func unmergeIntoProvisionalAccount(
        application id: UInt64,
        authType: AuthenticationExternalAuthType,
        token: String,
        _ body: @escaping UnmergeIntoProvisionalAccountCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in
            usingLock(
                Discord_Client_UnmergeIntoProvisionalAccount,
                id,
                authType.discordValue,
                str,
                unmergeIntoProvisionalAccountTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Updates the display name of a provisional account to the specified name.
    ///
    /// This should generally be invoked whenever the SDK starts and whenever a provisional account
    /// changes their name, since the auto-generated name for provisional accounts is just a random
    /// string.
    public func updateProvisionalAccountDisplayName(
        to name: String,
        _ body: @escaping UpdateProvisionalAccountDisplayNameCallback
    ) {
        let cb = CallbackBox(body)
        name.withDiscordString { str in
            usingLock(
                Discord_Client_UpdateProvisionalAccountDisplayName,
                str,
                updateProvisionalAccountDisplayNameTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
    /// Asynchronously sets a new auth token for this client to use.
    ///
    /// If your client is already connected, this function *may* trigger a reconnect.
    /// If your client is not connected, this function will only update the auth token, and so you
    /// must invoke ``connect()`` as well. You should wait for the given callback function to be
    /// invoked though so that the next ``connect()`` attempt uses the updated token.
    public func updateToken(
        to token: String,
        for type: AuthorizationTokenType,
        _ body: @escaping UpdateTokenCallback
    ) {
        let cb = CallbackBox(body)
        token.withDiscordString { str in
            usingLock(
                Discord_Client_UpdateToken,
                type.discordValue,
                str,
                updateTokenTrampoline,
                freeBox,
                cb.retainedOpaqueValue()
            )
        }
    }
    
}

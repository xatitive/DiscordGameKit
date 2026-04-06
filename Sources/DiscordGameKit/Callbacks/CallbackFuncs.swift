//
//  CallbackFuncs.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

let endCallTrampoline: Discord_Client_EndCallCallback = { ctx in
    CallbackBox<DiscordClient.EndCallCallback>.from(opaque: ctx)?()
}

let endCallsTrampoline: Discord_Client_EndCallsCallback = { ctx in
    CallbackBox<DiscordClient.EndCallsCallback>.from(opaque: ctx)?()
}

let getCurrentInputDeviceTrampoline: Discord_Client_GetCurrentInputDeviceCallback = { device, ctx in
    guard let device = convertRawObject(device, to: AudioDevice.self) else { return }
    CallbackBox<DiscordClient.CurrentInputDeviceCallback>.from(opaque: ctx)?(device)
}

let getCurrentOutputDeviceTrampoline: Discord_Client_GetCurrentOutputDeviceCallback = { device, ctx in
    guard let device = convertRawObject(device, to: AudioDevice.self) else { return }
    CallbackBox<DiscordClient.CurrentOutputDeviceCallback>.from(opaque: ctx)?(device)
}

let getInputDevicesTrampoline: Discord_Client_GetInputDevicesCallback = { devices, ctx in
    CallbackBox<DiscordClient.InputAudioDevicesCallback>.from(opaque: ctx)?(devices.converting())
}

let getOutputDevicesTrampoline: Discord_Client_GetOutputDevicesCallback = { devices, ctx in
    CallbackBox<DiscordClient.OutputAudioDevicesCallback>.from(opaque: ctx)?(devices.converting())
}

let deviceChangeTrampoline: Discord_Client_DeviceChangeCallback = { i, o, ctx in
    CallbackBox<DiscordClient.AudioDeviceChangedCallback>.from(opaque: ctx)?(i.converting(), o.converting())
}

let setInputDeviceTrampoline: Discord_Client_SetInputDeviceCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.SetAudioDeviceCallback>.from(opaque: ctx)?(result)
}

let noAudioTrampoline: Discord_Client_NoAudioInputCallback = { detected, ctx in
    CallbackBox<DiscordClient.NoAudioInputCallback>.from(opaque: ctx)?(detected)
}

let setOutputDeviceTrampoline: Discord_Client_SetOutputDeviceCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.SetAudioDeviceCallback>.from(opaque: ctx)?(result)
}

let voiceParticipantChangedTrampoline: Discord_Client_VoiceParticipantChangedCallback = { id1, id2, idk, ctx in
    CallbackBox<DiscordClient.VoiceParticipantChangedCallback>.from(opaque: ctx)?(id1, id2, idk)
}

let userAudioReceivedTrampoline: Discord_Client_UserAudioReceivedCallback = { uid, data, samp, sampRate, channels, shouldMute, ctx in
    CallbackBox<DiscordClient.UserAudioReceivedCallback>.from(opaque: ctx)?(
        uid,
        data,
        samp,
        sampRate,
        channels,
        shouldMute?.pointee ?? false
    )
}

let userAudioRCapturedTrampoline: Discord_Client_UserAudioCapturedCallback = { data, samp, sampRate, channels, ctx in
    CallbackBox<DiscordClient.UserAudioCapturedCallback>.from(opaque: ctx)?(
        data,
        samp,
        sampRate,
        channels
    )
}

let authorizationTrampoline: Discord_Client_AuthorizationCallback = { result, code, uri, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.AuthorizationCallback>.from(opaque: ctx)?(
        result,
        String(discordOwned: code),
        String(discordOwned: uri),
    )
}

let exchangeChildTokenTrampoline: Discord_Client_ExchangeChildTokenCallback = { result, token, tokType, expiry, scopes, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.ExchangeChildTokenCallback>.from(opaque: ctx)?(
        result,
        String(discordOwned: token),
        AuthorizationTokenType(rawValue: Int32(tokType.rawValue))!,
        expiry,
        String(discordOwned: scopes)
    )
}

let fetchCurrentUserTrampoline: Discord_Client_FetchCurrentUserCallback = { result, id, name, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.FetchCurrentUserCallback>.from(opaque: ctx)?(
        result,
        id,
        String(discordOwned: name)
    )
}

let tokenExchangeTrampoline: Discord_Client_TokenExchangeCallback = { result, accessToken, refreshToken, tokType, expiry, scopes, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.TokenExchangeCallback>.from(opaque: ctx)?(
        result,
        accessToken.toString(),
        refreshToken.toString(),
        AuthorizationTokenType(rawValue: Int32(tokType.rawValue))!,
        expiry,
        scopes.toString()
    )
}

let authRequestTrampoline: Discord_Client_AuthorizeRequestCallback = { ctx in
    CallbackBox<DiscordClient.AuthorizeRequestCallback>.from(opaque: ctx)?()
}

let revokeTokenTrampoline: Discord_Client_RevokeTokenCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.RevokeTokenCallback>.from(opaque: ctx)?(result)
}

let authDeviceScreenClosedTrampoline: Discord_Client_AuthorizeDeviceScreenClosedCallback = { ctx in
    CallbackBox<DiscordClient.AuthorizeDeviceScreenClosedCallback>.from(opaque: ctx)?()
}

let tokenExpirationTrampoline: Discord_Client_TokenExpirationCallback = { ctx in
    CallbackBox<DiscordClient.TokenExpirationCallback>.from(opaque: ctx)?()
}

let unmergeIntoProvisionalAccountTrampoline: Discord_Client_UnmergeIntoProvisionalAccountCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UnmergeIntoProvisionalAccountCallback>.from(opaque: ctx)?(result)
}

let updateProvisionalAccountDisplayNameTrampoline: Discord_Client_UpdateProvisionalAccountDisplayNameCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UpdateProvisionalAccountDisplayNameCallback>.from(opaque: ctx)?(result)
}

let updateTokenTrampoline: Discord_Client_UpdateTokenCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UpdateTokenCallback>.from(opaque: ctx)?(result)
}

let deleteUserMessageTrampoline: Discord_Client_DeleteUserMessageCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.DeleteUserMessageCallback>.from(opaque: ctx)?(result)
}

let editUserMessageTrampoline: Discord_Client_EditUserMessageCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.EditUserMessageCallback>.from(opaque: ctx)?(result)
}

let sendUserMessageTrampoline: Discord_Client_SendUserMessageCallback = { result, id, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.SendUserMessageCallback>.from(opaque: ctx)?(result, id)
}

let userMessagesLimitedTrampoline: Discord_Client_UserMessagesWithLimitCallback = { result, span, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UserMessagesWithLimitCallback>.from(opaque: ctx)?(
        result,
        span.converting()
    )
}

let userMessageSummariesTrampoline: Discord_Client_UserMessageSummariesCallback = { result, span, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UserMessageSummariesCallback>.from(opaque: ctx)?(
        result,
        span.converting()
    )
}

let provisionalUserMergeTrampoline: Discord_Client_ProvisionalUserMergeRequiredCallback = { ctx in
    CallbackBox<DiscordClient.ProvisionalUserMergeRequiredCallback>.from(opaque: ctx)?()
}

let openMessageDiscordTrampoline: Discord_Client_OpenMessageInDiscordCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.ClientResultCallback>.from(opaque: ctx)?(result)
}

let lobbyMessagesTrampoline: Discord_Client_GetLobbyMessagesCallback = { result, span, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.GetLobbyMessagesCallback>.from(opaque: ctx)?(
        result,
        span.converting()
    )
}

let messageCreatedTrampoline: Discord_Client_MessageCreatedCallback = { id, ctx in
    CallbackBox<DiscordClient.MessageCreatedCallback>.from(opaque: ctx)?(id)
}

let messageDeletedTrampoline: Discord_Client_MessageDeletedCallback = { msg, chl, ctx in
    CallbackBox<DiscordClient.MessageDeletedCallback>.from(opaque: ctx)?(msg, chl)
}

let messageUpdatedTrampoline: Discord_Client_MessageUpdatedCallback = { id, ctx in
    CallbackBox<DiscordClient.MessageUpdatedCallback>.from(opaque: ctx)?(id)
}

let logTrampoline: Discord_Client_LogCallback = { msg, sev, ctx in
    CallbackBox<DiscordClient.LogCallback>.from(opaque: ctx)?(
        String(discordOwned: msg),
        LoggingSeverity(rawValue: Int32(sev.rawValue))!
    )
}

let openConnectedGameSettingsTrampoline: Discord_Client_OpenConnectedGamesSettingsInDiscordCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.OpenConnectedGamesSettingsInDiscordCallback>.from(opaque: ctx)?(result)
}

let statusChangedTrampoline: Discord_Client_OnStatusChanged = { cStatus, cError, details, ctx in
    CallbackBox<DiscordClient.StatusChangedCallback>.from(opaque: ctx)?(
        ClientStatus(rawValue: .init(cStatus.rawValue))!,
        ClientError(rawValue: .init(cError.rawValue))!,
        details
    )
}

let createOrJoinLobbyTrampoline: Discord_Client_CreateOrJoinLobbyCallback = { result, id, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.CreateOrJoinLobbyCallback>.from(opaque: ctx)?(result, id)
}

let guildChannelsTrampoline: Discord_Client_GetGuildChannelsCallback = { result, span, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.GetGuildChannelsCallback>.from(opaque: ctx)?(
        result,
        span.converting()
    )
}

let userGuildsTrampoline: Discord_Client_GetUserGuildsCallback = { result, span, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.GetUserGuildsCallback>.from(opaque: ctx)?(
        result,
        span.converting()
    )
}

let joinLinkedLobbyTrampoline: Discord_Client_JoinLinkedLobbyGuildCallback = { result, invite, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.JoinLinkedLobbyGuildCallback>.from(opaque: ctx)?(
        result,
        invite.toString()
    )
}

let leaveLobbyTrampoline: Discord_Client_LeaveLobbyCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.LeaveLobbyCallback>.from(opaque: ctx)?(result)
}

let linkUnlinkChannelTrampoline: Discord_Client_LinkOrUnlinkChannelCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.LinkOrUnlinkChannelCallback>.from(opaque: ctx)?(result)
}

let lobbyCreatedTrampoline: Discord_Client_LobbyCreatedCallback = { id, ctx in
    CallbackBox<DiscordClient.LobbyCreatedCallback>.from(opaque: ctx)?(id)
}

let lobbyDeletedTrampoline: Discord_Client_LobbyDeletedCallback = { id, ctx in
    CallbackBox<DiscordClient.LobbyDeletedCallback>.from(opaque: ctx)?(id)
}

let lobbyMemberAddedTrampoline: Discord_Client_LobbyMemberAddedCallback = { id1, id2, ctx in
    CallbackBox<DiscordClient.LobbyMemberAddedCallback>.from(opaque: ctx)?(id1, id2)
}

let lobbyMemberRemovedTrampoline: Discord_Client_LobbyMemberRemovedCallback = { id1, id2, ctx in
    CallbackBox<DiscordClient.LobbyMemberRemovedCallback>.from(opaque: ctx)?(id1, id2)
}

let lobbyMemberUpdatedTrampoline: Discord_Client_LobbyMemberUpdatedCallback = { id1, id2, ctx in
    CallbackBox<DiscordClient.LobbyMemberUpdatedCallback>.from(opaque: ctx)?(id1, id2)
}

let lobbyUpdatedTrampoline: Discord_Client_LobbyUpdatedCallback = { id, ctx in
    CallbackBox<DiscordClient.LobbyUpdatedCallback>.from(opaque: ctx)?(id)
}

let appInstalledTrampoline: Discord_Client_IsDiscordAppInstalledCallback = { installed, ctx in
    CallbackBox<DiscordClient.IsDiscordAppInstalledCallback>.from(opaque: ctx)?(installed)
}

let acceptActivityInviteTrampoline: Discord_Client_AcceptActivityInviteCallback = { result, secret, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.AcceptActivityInviteCallback>.from(opaque: ctx)?(
        result,
        secret.toString()
    )
}

let sendActivityInviteTrampoline: Discord_Client_SendActivityInviteCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.SendActivityInviteCallback>.from(opaque: ctx)?(result)
}

let activityInviteTrampoline: Discord_Client_ActivityInviteCallback = { invite, ctx in
    guard let invite: ActivityInvite = convertRawObject(invite) else { return }
    CallbackBox<DiscordClient.ActivityInviteCallback>.from(opaque: ctx)?(invite)
}

let activityJoinTrampoline: Discord_Client_ActivityJoinCallback = { secret, ctx in
    CallbackBox<DiscordClient.ActivityJoinCallback>.from(opaque: ctx)?(
        secret.toString()
    )
}

let activityJoinApplicationTrampoline: Discord_Client_ActivityJoinWithApplicationCallback = { id, secret, ctx in
    CallbackBox<DiscordClient.ActivityJoinWithApplicationCallback>.from(opaque: ctx)?(
        id,
        secret.toString()
    )
}

let updateStatusTrampoline: Discord_Client_UpdateStatusCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UpdateStatusCallback>.from(opaque: ctx)?(result)
}

let updateRichPresenceTrampoline: Discord_Client_UpdateRichPresenceCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UpdateStatusCallback>.from(opaque: ctx)?(result)
}

let updateRelationshipTrampoline: Discord_Client_UpdateRelationshipCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.UpdateRelationshipCallback>.from(opaque: ctx)?(result)
}

let sendFriendReqTrampoline: Discord_Client_SendFriendRequestCallback = { result, ctx in
    guard let result: ClientResult = convertRawObject(result) else { return }
    CallbackBox<DiscordClient.SendFriendRequestCallback>.from(opaque: ctx)?(result)
}

let relationshipCreatedTrampoline: Discord_Client_RelationshipCreatedCallback = { id, discordRelated, ctx in
    CallbackBox<DiscordClient.RelationshipCreatedCallback>.from(opaque: ctx)?(
        id,
        discordRelated
    )
}

let relationshipDeletedTrampoline: Discord_Client_RelationshipDeletedCallback = { id, discordRelated, ctx in
    CallbackBox<DiscordClient.RelationshipDeletedCallback>.from(opaque: ctx)?(
		id,
        discordRelated
    )
}

let connectedClientTrampoline: Discord_Client_GetDiscordClientConnectedUserCallback = { result, handle, ctx in
    guard
        let result: ClientResult = convertRawObject(result),
        let handle: UserHandle = convertRawObject(handle)
    else { return }
    CallbackBox<DiscordClient.GetDiscordClientConnectedUserCallback>.from(opaque: ctx)?(result, handle)
}

let relationshipGroupUpdate: Discord_Client_RelationshipGroupsUpdatedCallback = { id, ctx in
    CallbackBox<DiscordClient.RelationshipGroupsUpdatedCallback>.from(opaque: ctx)?(id)
}

let userUpdatedTrampoline: Discord_Client_UserUpdatedCallback = { id, ctx in
    CallbackBox<DiscordClient.UserUpdatedCallback>.from(opaque: ctx)?(id)
}


//Discord_Client_EndCallCallback ƒ
//Discord_Client_EndCallsCallback ƒ
//Discord_Client_GetCurrentInputDeviceCallback ƒ
//Discord_Client_GetCurrentOutputDeviceCallback ƒ
//Discord_Client_GetInputDevicesCallback ƒ
//Discord_Client_GetOutputDevicesCallback ƒ
//Discord_Client_DeviceChangeCallback ƒ
//Discord_Client_SetInputDeviceCallback ƒ
//Discord_Client_NoAudioInputCallback ƒ
//Discord_Client_SetOutputDeviceCallback ƒ
//Discord_Client_VoiceParticipantChangedCallback ƒ
//Discord_Client_UserAudioReceivedCallback ƒ
//Discord_Client_UserAudioCapturedCallback ƒ
//Discord_Client_AuthorizationCallback ƒ
//Discord_Client_ExchangeChildTokenCallback ƒ
//Discord_Client_FetchCurrentUserCallback ƒ
//Discord_Client_TokenExchangeCallback ƒ
//Discord_Client_AuthorizeRequestCallback ƒ
//Discord_Client_RevokeTokenCallback ƒ
//Discord_Client_AuthorizeDeviceScreenClosedCallback ƒ
//Discord_Client_TokenExpirationCallback ƒ
//Discord_Client_UnmergeIntoProvisionalAccountCallback ƒ
//Discord_Client_UpdateProvisionalAccountDisplayNameCallback ƒ
//Discord_Client_UpdateTokenCallback ƒ
//Discord_Client_DeleteUserMessageCallback ƒ
//Discord_Client_EditUserMessageCallback ƒ
//Discord_Client_GetLobbyMessagesCallback ƒ
//Discord_Client_UserMessageSummariesCallback ƒ
//Discord_Client_UserMessagesWithLimitCallback ƒ
//Discord_Client_ProvisionalUserMergeRequiredCallback ƒ
//Discord_Client_OpenMessageInDiscordCallback ƒ
//Discord_Client_SendUserMessageCallback ƒ
//Discord_Client_MessageCreatedCallback ƒ
//Discord_Client_MessageDeletedCallback ƒ
//Discord_Client_MessageUpdatedCallback ƒ
//Discord_Client_LogCallback ƒ
//Discord_Client_OpenConnectedGamesSettingsInDiscordCallback ƒ
//Discord_Client_OnStatusChanged ƒ
//Discord_Client_CreateOrJoinLobbyCallback ƒ
//Discord_Client_GetGuildChannelsCallback ƒ
//Discord_Client_GetUserGuildsCallback ƒ
//Discord_Client_JoinLinkedLobbyGuildCallback ƒ
//Discord_Client_LeaveLobbyCallback ƒ
//Discord_Client_LinkOrUnlinkChannelCallback ƒ
//Discord_Client_LobbyCreatedCallback ƒ
//Discord_Client_LobbyDeletedCallback ƒ
//Discord_Client_LobbyMemberAddedCallback ƒ
//Discord_Client_LobbyMemberRemovedCallback ƒ
//Discord_Client_LobbyMemberUpdatedCallback ƒ
//Discord_Client_LobbyUpdatedCallback ƒ
//Discord_Client_IsDiscordAppInstalledCallback ƒ
//Discord_Client_AcceptActivityInviteCallback ƒ
//Discord_Client_SendActivityInviteCallback ƒ
//Discord_Client_ActivityInviteCallback ƒ
//Discord_Client_ActivityJoinCallback ƒ
//Discord_Client_ActivityJoinWithApplicationCallback ƒ
//Discord_Client_UpdateStatusCallback ƒ
//Discord_Client_UpdateRichPresenceCallback ƒ
//Discord_Client_UpdateRelationshipCallback ƒ
//Discord_Client_SendFriendRequestCallback ƒ
//Discord_Client_RelationshipCreatedCallback ƒ
//Discord_Client_RelationshipDeletedCallback ƒ
//Discord_Client_GetDiscordClientConnectedUserCallback ƒ
//Discord_Client_RelationshipGroupsUpdatedCallback ƒ
//Discord_Client_UserUpdatedCallback ƒ

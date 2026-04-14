//
//  Span_Shims.h
//  DiscordGameKit
//
//  Created by Christian Norton on 4/14/26.
//

#ifndef SPAN_SHIMS
#define SPAN_SHIMS

#include "cdiscord.h"
#include <lifetimebound.h>
#include <ptrcheck.h>
#include <sys/types.h>


// MARK: - Activity Invite
static inline void Discord_ActivityInvite_SetPartyId_Span(Discord_ActivityInvite*__nonnull self,
                                                          const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                          size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityInvite_SetPartyId(self, str);
};

static inline void Discord_ActivityInvite_PartyId_Span(Discord_ActivityInvite*__nonnull self,
                                                       uint8_t *__nonnull __counted_by(size) output __noescape,
                                                       size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ActivityInvite_PartyId(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_ActivityInvite_SetSessionId_Span(Discord_ActivityInvite*__nonnull self,
                                                          const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                          size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityInvite_SetSessionId(self, str);
};

static inline void Discord_ActivityInvite_SessionId_Span(Discord_ActivityInvite*__nonnull self,
                                                       uint8_t *__nonnull __counted_by(size) output __noescape,
                                                       size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ActivityInvite_SessionId(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Activity Assets
static inline void Discord_ActivityAssets_SetLargeImage_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetLargeImage(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetLargeImage(self, &str);
};

static inline bool Discord_ActivityAssets_LargeImage_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_LargeImage(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_ActivityAssets_SetLargeText_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetLargeText(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetLargeText(self, &str);
};

static inline bool Discord_ActivityAssets_LargeText_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_LargeText(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_ActivityAssets_SetLargeUrl_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetLargeUrl(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetLargeUrl(self, &str);
};

static inline bool Discord_ActivityAssets_LargeUrl_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_LargeUrl(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_ActivityAssets_SetSmallImage_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetSmallImage(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetSmallImage(self, &str);
};

static inline bool Discord_ActivityAssets_SmallImage_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_SmallImage(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_ActivityAssets_SetSmallText_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetSmallText(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetSmallText(self, &str);
};

static inline bool Discord_ActivityAssets_SmallText_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_SmallText(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_ActivityAssets_SetSmallUrl_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetSmallUrl(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetSmallUrl(self, &str);
};

static inline bool Discord_ActivityAssets_SmallUrl_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_SmallUrl(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_ActivityAssets_SetInviteCoverImage_Span(
    Discord_ActivityAssets*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_ActivityAssets_SetInviteCoverImage(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityAssets_SetInviteCoverImage(self, &str);
};

static inline bool Discord_ActivityAssets_InviteCoverImage_Span(
    Discord_ActivityAssets*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_ActivityAssets_InviteCoverImage(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

// MARK: - Activity Party
static inline void Discord_ActivityParty_SetId_Span(Discord_ActivityParty*__nonnull self,
                                                    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                    size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityParty_SetId(self, str);
};

static inline void Discord_ActivityParty_Id_Span(Discord_ActivityParty*__nonnull self,
                                                 uint8_t *__nonnull __counted_by(size) output __noescape,
                                                 size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ActivityParty_Id(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Activity Secrets
static inline void Discord_ActivitySecrets_SetJoin_Span(Discord_ActivitySecrets*__nonnull self,
                                                        const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                        size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivitySecrets_SetJoin(self, str);
};

static inline void Discord_ActivitySecrets_Join_Span(Discord_ActivitySecrets*__nonnull self,
                                                     uint8_t *__nonnull __counted_by(size) output __noescape,
                                                     size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ActivitySecrets_Join(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Activity Button
static inline void Discord_ActivityButton_SetLabel_Span(Discord_ActivityButton*__nonnull self,
                                                        const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                        size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityButton_SetLabel(self, str);
};

static inline void Discord_ActivityButton_Label_Span(Discord_ActivityButton*__nonnull self,
                                                     uint8_t *__nonnull __counted_by(size) output __noescape,
                                                     size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ActivityButton_Label(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_ActivityButton_SetUrl_Span(Discord_ActivityButton*__nonnull self,
                                                      const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                      size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ActivityButton_SetUrl(self, str);
};

static inline void Discord_ActivityButton_Url_Span(Discord_ActivityButton*__nonnull self,
                                                   uint8_t *__nonnull __counted_by(size) output __noescape,
                                                   size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ActivityButton_Url(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Client Result
static inline void Discord_ClientResult_ToString_Span(Discord_ClientResult*__nonnull self,
                                                      uint8_t *__nonnull __counted_by(size) output __noescape,
                                                      size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ClientResult_ToString(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_ClientResult_SetError_Span(Discord_ClientResult*__nonnull self,
                                                      const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                      size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ClientResult_SetError(self, str);
};

static inline void Discord_ClientResult_Error_Span(Discord_ClientResult*__nonnull self,
                                                   uint8_t *__nonnull __counted_by(size) output __noescape,
                                                   size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ClientResult_Error(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_ClientResult_SetResponseBody_Span(Discord_ClientResult*__nonnull self,
                                                             const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                             size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ClientResult_SetResponseBody(self, str);
};

static inline void Discord_ClientResult_ResponseBody_Span(Discord_ClientResult*__nonnull self,
                                                          uint8_t *__nonnull __counted_by(size) output __noescape,
                                                          size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ClientResult_ResponseBody(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Auth Code Challenge
static inline void Discord_AuthorizationCodeChallenge_SetChallenge_Span(
    Discord_AuthorizationCodeChallenge*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AuthorizationCodeChallenge_SetChallenge(self, str);
};

static inline void Discord_AuthorizationCodeChallenge_Challenge_Span(
    Discord_AuthorizationCodeChallenge*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_AuthorizationCodeChallenge_Challenge(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Auth Code Verifier
static inline void Discord_AuthorizationCodeVerifier_SetVerifier_Span(
    Discord_AuthorizationCodeVerifier*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AuthorizationCodeVerifier_SetVerifier(self, str);
};

static inline void Discord_AuthorizationCodeVerifier_Verifier_Span(
    Discord_AuthorizationCodeVerifier*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_AuthorizationCodeVerifier_Verifier(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Auth Args
static inline void Discord_AuthorizationArgs_SetScopes_Span(Discord_AuthorizationArgs*__nonnull self,
                                                            const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                            size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AuthorizationArgs_SetScopes(self, str);
};

static inline void Discord_AuthorizationArgs_Scopes_Span(Discord_AuthorizationArgs*__nonnull self,
                                                         uint8_t *__nonnull __counted_by(size) output __noescape,
                                                         size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_AuthorizationArgs_Scopes(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_AuthorizationArgs_SetState_Span(Discord_AuthorizationArgs*__nonnull self,
                                                           const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                           size_t size)
{
    if (ptr == NULL) {
        Discord_AuthorizationArgs_SetState(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AuthorizationArgs_SetState(self, &str);
};

static inline bool Discord_AuthorizationArgs_State_Span(Discord_AuthorizationArgs*__nonnull self,
                                                        uint8_t *__nonnull __counted_by(size) output __noescape,
                                                        size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_AuthorizationArgs_State(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_AuthorizationArgs_SetNonce_Span(Discord_AuthorizationArgs*__nonnull self,
                                                           const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                           size_t size)
{
    if (ptr == NULL) {
        Discord_AuthorizationArgs_SetNonce(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AuthorizationArgs_SetNonce(self, &str);
};

static inline bool Discord_AuthorizationArgs_Nonce_Span(Discord_AuthorizationArgs*__nonnull self,
                                                        uint8_t *__nonnull __counted_by(size) output __noescape,
                                                        size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_AuthorizationArgs_Nonce(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_AuthorizationArgs_SetCustomSchemeParam_Span(
    Discord_AuthorizationArgs*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    if (ptr == NULL) {
        Discord_AuthorizationArgs_SetCustomSchemeParam(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AuthorizationArgs_SetCustomSchemeParam(self, &str);
};

static inline bool Discord_AuthorizationArgs_CustomSchemeParam_Span(
    Discord_AuthorizationArgs*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_AuthorizationArgs_CustomSchemeParam(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

// MARK: - Device Auth Args
static inline void Discord_DeviceAuthorizationArgs_SetScopes_Span(
    Discord_DeviceAuthorizationArgs*__nonnull self,
    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
    size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_DeviceAuthorizationArgs_SetScopes(self, str);
};

static inline void Discord_DeviceAuthorizationArgs_Scopes_Span(
    Discord_DeviceAuthorizationArgs*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_DeviceAuthorizationArgs_Scopes(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Enum ToString
static inline void Discord_Call_ErrorToString_Span(Discord_Call_Error type,
                                                   uint8_t *__nonnull __counted_by(size) output __noescape,
                                                   size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_Call_ErrorToString(type, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_Call_StatusToString_Span(Discord_Call_Status type,
                                                    uint8_t *__nonnull __counted_by(size) output __noescape,
                                                    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_Call_StatusToString(type, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_UserHandle_AvatarTypeToString_Span(
    Discord_UserHandle_AvatarType type,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserHandle_AvatarTypeToString(type, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_AdditionalContent_TypeToString_Span(
    Discord_AdditionalContentType type,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_AdditionalContent_TypeToString(type, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_Client_ErrorToString_Span(Discord_Client_Error type,
                                                     uint8_t *__nonnull __counted_by(size) output __noescape,
                                                     size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_Client_ErrorToString(type, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_Client_StatusToString_Span(Discord_Client_Status type,
                                                      uint8_t *__nonnull __counted_by(size) output __noescape,
                                                      size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_Client_StatusToString(type, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_Client_ThreadToString_Span(Discord_Client_Thread type,
                                                      uint8_t *__nonnull __counted_by(size) output __noescape,
                                                      size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_Client_ThreadToString(type, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Channel Handle
static inline void Discord_ChannelHandle_Name_Span(Discord_ChannelHandle*__nonnull self,
                                                   uint8_t *__nonnull __counted_by(size) output __noescape,
                                                   size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ChannelHandle_Name(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Guild Minimal
static inline void Discord_GuildMinimal_SetName_Span(Discord_GuildMinimal*__nonnull self,
                                                     const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                     size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_GuildMinimal_SetName(self, str);
};

static inline void Discord_GuildMinimal_Name_Span(Discord_GuildMinimal*__nonnull self,
                                                  uint8_t *__nonnull __counted_by(size) output __noescape,
                                                  size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_GuildMinimal_Name(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Guild Channel
static inline void Discord_GuildChannel_SetName_Span(Discord_GuildChannel*__nonnull self,
                                                     const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                     size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_GuildChannel_SetName(self, str);
};

static inline void Discord_GuildChannel_Name_Span(Discord_GuildChannel*__nonnull self,
                                                  uint8_t *__nonnull __counted_by(size) output __noescape,
                                                  size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_GuildChannel_Name(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - User Application Profile Handle
static inline void Discord_UserApplicationProfileHandle_AvatarHash_Span(
    Discord_UserApplicationProfileHandle*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserApplicationProfileHandle_AvatarHash(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_UserApplicationProfileHandle_Metadata_Span(
    Discord_UserApplicationProfileHandle*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserApplicationProfileHandle_Metadata(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline bool Discord_UserApplicationProfileHandle_ProviderId_Span(
    Discord_UserApplicationProfileHandle*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_UserApplicationProfileHandle_ProviderId(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_UserApplicationProfileHandle_ProviderIssuedUserId_Span(
    Discord_UserApplicationProfileHandle*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserApplicationProfileHandle_ProviderIssuedUserId(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_UserApplicationProfileHandle_Username_Span(
    Discord_UserApplicationProfileHandle*__nonnull self,
    uint8_t *__nonnull __counted_by(size) output __noescape,
    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserApplicationProfileHandle_Username(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - User Handle
static inline bool Discord_UserHandle_Avatar_Span(Discord_UserHandle*__nonnull self,
                                                  uint8_t *__nonnull __counted_by(size) output __noescape,
                                                  size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_UserHandle_Avatar(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_UserHandle_AvatarUrl_Span(Discord_UserHandle*__nonnull self,
                                                     Discord_UserHandle_AvatarType animatedType,
                                                     Discord_UserHandle_AvatarType staticType,
                                                     uint8_t *__nonnull __counted_by(size) output __noescape,
                                                     size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserHandle_AvatarUrl(self, animatedType, staticType, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_UserHandle_DisplayName_Span(Discord_UserHandle*__nonnull self,
                                                       uint8_t *__nonnull __counted_by(size) output __noescape,
                                                       size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserHandle_DisplayName(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline bool Discord_UserHandle_GlobalName_Span(Discord_UserHandle*__nonnull self,
                                                      uint8_t *__nonnull __counted_by(size) output __noescape,
                                                      size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_UserHandle_GlobalName(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

static inline void Discord_UserHandle_Username_Span(Discord_UserHandle*__nonnull self,
                                                    uint8_t *__nonnull __counted_by(size) output __noescape,
                                                    size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_UserHandle_Username(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Additional Content
static inline void Discord_AdditionalContent_SetTitle_Span(Discord_AdditionalContent*__nonnull self,
                                                           const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                           size_t size)
{
    if (ptr == NULL) {
        Discord_AdditionalContent_SetTitle(self, NULL);
        return;
    }
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AdditionalContent_SetTitle(self, &str);
};

static inline bool Discord_AdditionalContent_Title_Span(Discord_AdditionalContent*__nonnull self,
                                                        uint8_t *__nonnull __counted_by(size) output __noescape,
                                                        size_t size)
{
    Discord_String str = { NULL, 0 };
    bool hasValue = Discord_AdditionalContent_Title(self, &str);
    output = str.ptr;
    size = str.size;
    return hasValue;
};

// MARK: - Linked Channel
static inline void Discord_LinkedChannel_SetName_Span(Discord_LinkedChannel*__nonnull self,
                                                      const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                      size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_LinkedChannel_SetName(self, str);
};

static inline void Discord_LinkedChannel_Name_Span(Discord_LinkedChannel*__nonnull self,
                                                   uint8_t *__nonnull __counted_by(size) output __noescape,
                                                   size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_LinkedChannel_Name(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Message Handle
static inline void Discord_MessageHandle_Content_Span(Discord_MessageHandle*__nonnull self,
                                                      uint8_t *__nonnull __counted_by(size) output __noescape,
                                                      size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_MessageHandle_Content(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_MessageHandle_RawContent_Span(Discord_MessageHandle*__nonnull self,
                                                         uint8_t *__nonnull __counted_by(size) output __noescape,
                                                         size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_MessageHandle_RawContent(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Audio Device
static inline void Discord_AudioDevice_SetId_Span(Discord_AudioDevice*__nonnull self,
                                                  const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                  size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AudioDevice_SetId(self, str);
};

static inline void Discord_AudioDevice_Id_Span(Discord_AudioDevice*__nonnull self,
                                               uint8_t *__nonnull __counted_by(size) output __noescape,
                                               size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_AudioDevice_Id(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_AudioDevice_SetName_Span(Discord_AudioDevice*__nonnull self,
                                                    const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                    size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_AudioDevice_SetName(self, str);
};

static inline void Discord_AudioDevice_Name_Span(Discord_AudioDevice*__nonnull self,
                                                 uint8_t *__nonnull __counted_by(size) output __noescape,
                                                 size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_AudioDevice_Name(self, &str);
    output = str.ptr;
    size = str.size;
};

// MARK: - Client Create Options
static inline void Discord_ClientCreateOptions_SetWebBase_Span(Discord_ClientCreateOptions*__nonnull self,
                                                               const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                               size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ClientCreateOptions_SetWebBase(self, str);
};

static inline void Discord_ClientCreateOptions_WebBase_Span(Discord_ClientCreateOptions*__nonnull self,
                                                            uint8_t *__nonnull __counted_by(size) output __noescape,
                                                            size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ClientCreateOptions_WebBase(self, &str);
    output = str.ptr;
    size = str.size;
};

static inline void Discord_ClientCreateOptions_SetApiBase_Span(Discord_ClientCreateOptions*__nonnull self,
                                                               const uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                               size_t size)
{
    Discord_String str = { (uint8_t*)ptr, size };
    Discord_ClientCreateOptions_SetApiBase(self, str);
};

static inline void Discord_ClientCreateOptions_ApiBase_Span(Discord_ClientCreateOptions*__nonnull self,
                                                            uint8_t *__nonnull __counted_by(size) output __noescape,
                                                            size_t size)
{
    Discord_String str = { NULL, 0 };
    Discord_ClientCreateOptions_ApiBase(self, &str);
    output = str.ptr;
    size = str.size;
};


//// TODO: Figure out how to convert Discord_Properties
//// MARK: -  Funcs to convert to a span equivalent.
//// MARK: ActivityInvite
//
//void DISCORD_API Discord_ActivityInvite_SetPartyId(Discord_ActivityInvite* self,
//                                                   Discord_String value); ƒ
//void DISCORD_API Discord_ActivityInvite_PartyId(Discord_ActivityInvite* self,
//                                                Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityInvite_SetSessionId(Discord_ActivityInvite* self,
//                                                     Discord_String value);
//void DISCORD_API Discord_ActivityInvite_SessionId(Discord_ActivityInvite* self,
//                                                  Discord_String* returnValue);
//
//// MARK: Activity Assets
//
//void DISCORD_API Discord_ActivityAssets_SetLargeImage(Discord_ActivityAssets* self,
//                                                      Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_LargeImage(Discord_ActivityAssets* self,
//                                                   Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityAssets_SetLargeText(Discord_ActivityAssets* self,
//                                                     Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_LargeText(Discord_ActivityAssets* self,
//                                                  Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityAssets_SetLargeUrl(Discord_ActivityAssets* self,
//                                                    Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_LargeUrl(Discord_ActivityAssets* self,
//                                                 Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityAssets_SetSmallImage(Discord_ActivityAssets* self,
//                                                      Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_SmallImage(Discord_ActivityAssets* self,
//                                                   Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityAssets_SetSmallText(Discord_ActivityAssets* self,
//                                                     Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_SmallText(Discord_ActivityAssets* self,
//                                                  Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityAssets_SetSmallUrl(Discord_ActivityAssets* self,
//                                                    Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_SmallUrl(Discord_ActivityAssets* self,
//                                                 Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityAssets_SetInviteCoverImage(Discord_ActivityAssets* self,
//                                                            Discord_String* value); ƒ
//bool DISCORD_API Discord_ActivityAssets_InviteCoverImage(Discord_ActivityAssets* self,
//                                                         Discord_String* returnValue); ƒ
//
//// MARK: Activity Party
//
//void DISCORD_API Discord_ActivityParty_SetId(Discord_ActivityParty* self, Discord_String value); ƒ
//void DISCORD_API Discord_ActivityParty_Id(Discord_ActivityParty* self, Discord_String* returnValue); ƒ
//
//// MARK: Activity Secrets
//
//void DISCORD_API Discord_ActivitySecrets_SetJoin(Discord_ActivitySecrets* self,
//                                                 Discord_String value); ƒ
//void DISCORD_API Discord_ActivitySecrets_Join(Discord_ActivitySecrets* self,
//                                              Discord_String* returnValue); ƒ
//
//// MARK: Activity Button
//
//void DISCORD_API Discord_ActivityButton_SetLabel(Discord_ActivityButton* self,
//                                                 Discord_String value); ƒ
//void DISCORD_API Discord_ActivityButton_Label(Discord_ActivityButton* self,
//                                              Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ActivityButton_SetUrl(Discord_ActivityButton* self, Discord_String value);
//void DISCORD_API Discord_ActivityButton_Url(Discord_ActivityButton* self,
//                                            Discord_String* returnValue); ƒ
//
//// MARK: Activity
//
//void DISCORD_API Discord_Activity_SetName(Discord_Activity* self, Discord_String value);
//void DISCORD_API Discord_Activity_Name(Discord_Activity* self, Discord_String* returnValue);
//void DISCORD_API Discord_Activity_SetState(Discord_Activity* self, Discord_String* value);
//bool DISCORD_API Discord_Activity_State(Discord_Activity* self, Discord_String* returnValue);
//void DISCORD_API Discord_Activity_SetStateUrl(Discord_Activity* self, Discord_String* value);
//bool DISCORD_API Discord_Activity_StateUrl(Discord_Activity* self, Discord_String* returnValue);
//void DISCORD_API Discord_Activity_SetDetails(Discord_Activity* self, Discord_String* value);
//bool DISCORD_API Discord_Activity_Details(Discord_Activity* self, Discord_String* returnValue);
//void DISCORD_API Discord_Activity_SetDetailsUrl(Discord_Activity* self, Discord_String* value);
//bool DISCORD_API Discord_Activity_DetailsUrl(Discord_Activity* self, Discord_String* returnValue);
//
//// MARK: Client Result
//
//void DISCORD_API Discord_ClientResult_ToString(Discord_ClientResult* self,
//                                               Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ClientResult_SetError(Discord_ClientResult* self,
//                                               Discord_String value); ƒ
//void DISCORD_API Discord_ClientResult_Error(Discord_ClientResult* self,
//                                            Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ClientResult_SetResponseBody(Discord_ClientResult* self,
//                                                      Discord_String value); ƒ
//void DISCORD_API Discord_ClientResult_ResponseBody(Discord_ClientResult* self,
//                                                   Discord_String* returnValue); ƒ
//
//// MARK: Auth Code Challenge
//
//void DISCORD_API
//Discord_AuthorizationCodeChallenge_SetChallenge(Discord_AuthorizationCodeChallenge* self,
//                                                Discord_String value); ƒ
//void DISCORD_API
//Discord_AuthorizationCodeChallenge_Challenge(Discord_AuthorizationCodeChallenge* self,
//                                             Discord_String* returnValue); ƒ
//
//// MARK: Auth Code Verifier
//
//void DISCORD_API
//Discord_AuthorizationCodeVerifier_SetVerifier(Discord_AuthorizationCodeVerifier* self,
//                                              Discord_String value); ƒ
//void DISCORD_API Discord_AuthorizationCodeVerifier_Verifier(Discord_AuthorizationCodeVerifier* self,
//                                                            Discord_String* returnValue); ƒ
//
//// MARK: Auth Args
//
//void DISCORD_API Discord_AuthorizationArgs_SetClientId(Discord_AuthorizationArgs* self,
//                                                       uint64_t value); ƒ
//uint64_t DISCORD_API Discord_AuthorizationArgs_ClientId(Discord_AuthorizationArgs* self); ƒ
//void DISCORD_API Discord_AuthorizationArgs_SetScopes(Discord_AuthorizationArgs* self,
//                                                     Discord_String value); ƒ
//void DISCORD_API Discord_AuthorizationArgs_Scopes(Discord_AuthorizationArgs* self,
//                                                  Discord_String* returnValue); ƒ
//void DISCORD_API Discord_AuthorizationArgs_SetState(Discord_AuthorizationArgs* self,
//                                                    Discord_String* value); ƒ
//bool DISCORD_API Discord_AuthorizationArgs_State(Discord_AuthorizationArgs* self,
//                                                 Discord_String* returnValue); ƒ
//void DISCORD_API Discord_AuthorizationArgs_SetNonce(Discord_AuthorizationArgs* self,
//                                                    Discord_String* value); ƒ
//bool DISCORD_API Discord_AuthorizationArgs_Nonce(Discord_AuthorizationArgs* self,
//                                                 Discord_String* returnValue); ƒ
//void DISCORD_API Discord_AuthorizationArgs_SetCustomSchemeParam(Discord_AuthorizationArgs* self,
//                                                                Discord_String* value); ƒ
//bool DISCORD_API Discord_AuthorizationArgs_CustomSchemeParam(Discord_AuthorizationArgs* self,
//                                                             Discord_String* returnValue); ƒ
//
//// MARK: Device Auth Args
//
//void DISCORD_API Discord_DeviceAuthorizationArgs_SetScopes(Discord_DeviceAuthorizationArgs* self,
//                                                           Discord_String value); ƒ
//void DISCORD_API Discord_DeviceAuthorizationArgs_Scopes(Discord_DeviceAuthorizationArgs* self,
//                                                        Discord_String* returnValue); ƒ
//
//// MARK: Call
//
//void DISCORD_API Discord_Call_ErrorToString(Discord_Call_Error type, Discord_String* returnValue); ƒ
//void DISCORD_API Discord_Call_StatusToString(Discord_Call_Status type, Discord_String* returnValue); ƒ
//
//// MARK: Channel Handle
//
//void DISCORD_API Discord_ChannelHandle_Name(Discord_ChannelHandle* self,
//                                            Discord_String* returnValue); ƒ
//void DISCORD_API Discord_ChannelHandle_Recipients(Discord_ChannelHandle* self,
//                                                  Discord_UInt64Span* returnValue); ƒ
//
//// MARK: Guild Minimal
//
//void DISCORD_API Discord_GuildMinimal_SetName(Discord_GuildMinimal* self, Discord_String value); ƒ
//void DISCORD_API Discord_GuildMinimal_Name(Discord_GuildMinimal* self, Discord_String* returnValue); ƒ
//
//// MARK: Guild Channel
//
//void DISCORD_API Discord_GuildChannel_SetName(Discord_GuildChannel* self, Discord_String value); ƒ
//void DISCORD_API Discord_GuildChannel_Name(Discord_GuildChannel* self, Discord_String* returnValue); ƒ
//
//// MARK: Linked Channel
//
//void DISCORD_API Discord_LinkedChannel_SetName(Discord_LinkedChannel* self, Discord_String value);
//void DISCORD_API Discord_LinkedChannel_Name(Discord_LinkedChannel* self,
//                                            Discord_String* returnValue);
//
//// MARK: User Application Profile Handle
//
//void DISCORD_API Discord_UserApplicationProfileHandle_AvatarHash(Discord_UserApplicationProfileHandle* self,
//                                                                 Discord_String* returnValue); ƒ
//
//void DISCORD_API Discord_UserApplicationProfileHandle_Metadata(Discord_UserApplicationProfileHandle* self,
//                                                               Discord_String* returnValue); ƒ
//
//bool DISCORD_API Discord_UserApplicationProfileHandle_ProviderId(Discord_UserApplicationProfileHandle* self,
//                                                                 Discord_String* returnValue); ƒ
//
//void DISCORD_API Discord_UserApplicationProfileHandle_ProviderIssuedUserId(Discord_UserApplicationProfileHandle* self,
//                                                                           Discord_String* returnValue); ƒ
//
//void DISCORD_API Discord_UserApplicationProfileHandle_Username(Discord_UserApplicationProfileHandle* self,
//                                                               Discord_String* returnValue); ƒ
//
//// MARK: User Handle
//
//bool DISCORD_API Discord_UserHandle_Avatar(Discord_UserHandle* self, Discord_String* returnValue); ƒ
//void DISCORD_API Discord_UserHandle_AvatarTypeToString(Discord_UserHandle_AvatarType type,
//                                                       Discord_String* returnValue); ƒ
//void DISCORD_API Discord_UserHandle_AvatarUrl(Discord_UserHandle* self,
//                                              Discord_UserHandle_AvatarType animatedType,
//                                              Discord_UserHandle_AvatarType staticType,
//                                              Discord_String* returnValue); ƒ
//void DISCORD_API Discord_UserHandle_DisplayName(Discord_UserHandle* self,
//                                                Discord_String* returnValue); ƒ
//bool DISCORD_API Discord_UserHandle_GameActivity(Discord_UserHandle* self,
//                                                 Discord_Activity* returnValue); ƒ
//bool DISCORD_API Discord_UserHandle_GlobalName(Discord_UserHandle* self,
//                                               Discord_String* returnValue); ƒ
//void DISCORD_API Discord_UserHandle_Username(Discord_UserHandle* self, Discord_String* returnValue); ƒ
//
//// MARK: Additional Content
//
//void DISCORD_API Discord_AdditionalContent_TypeToString(Discord_AdditionalContentType type,
//                                                        Discord_String* returnValue); ƒ
//void DISCORD_API Discord_AdditionalContent_SetTitle(Discord_AdditionalContent* self,
//                                                    Discord_String* value); ƒ
//bool DISCORD_API Discord_AdditionalContent_Title(Discord_AdditionalContent* self,
//                                                 Discord_String* returnValue); ƒ
//
//// MARK: Message Handle
//
//void DISCORD_API Discord_MessageHandle_Content(Discord_MessageHandle* self,
//                                               Discord_String* returnValue);
//void DISCORD_API Discord_MessageHandle_RawContent(Discord_MessageHandle* self,
//                                                  Discord_String* returnValue);
//
//// MARK: Audio Devices
//
//void DISCORD_API Discord_AudioDevice_SetId(Discord_AudioDevice* self, Discord_String value);
//void DISCORD_API Discord_AudioDevice_Id(Discord_AudioDevice* self, Discord_String* returnValue);
//void DISCORD_API Discord_AudioDevice_SetName(Discord_AudioDevice* self, Discord_String value);
//void DISCORD_API Discord_AudioDevice_Name(Discord_AudioDevice* self, Discord_String* returnValue);
//
//// MARK: Client Create Options
//
//void DISCORD_API Discord_ClientCreateOptions_SetWebBase(Discord_ClientCreateOptions* self,
//                                                        Discord_String value);
//void DISCORD_API Discord_ClientCreateOptions_WebBase(Discord_ClientCreateOptions* self,
//                                                     Discord_String* returnValue);
//void DISCORD_API Discord_ClientCreateOptions_SetApiBase(Discord_ClientCreateOptions* self,
//                                                        Discord_String value);
//void DISCORD_API Discord_ClientCreateOptions_ApiBase(Discord_ClientCreateOptions* self,
//                                                     Discord_String* returnValue);
//
//// MARK: Client
//
//void DISCORD_API Discord_Client_ErrorToString(Discord_Client_Error type,
//                                              Discord_String* returnValue);
//void DISCORD_API Discord_Client_GetDefaultAudioDeviceId(Discord_String* returnValue);
//void DISCORD_API Discord_Client_GetDefaultCommunicationScopes(Discord_String* returnValue);
//void DISCORD_API Discord_Client_GetDefaultPresenceScopes(Discord_String* returnValue);
//void DISCORD_API Discord_Client_GetVersionHash(Discord_String* returnValue);
//
#endif

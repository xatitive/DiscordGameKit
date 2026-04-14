//
//  Span_Shims.h
//  DiscordGameKit
//
//  Created by Christian Norton on 4/14/26.
//

#ifndef SPAN_SHIMS
#define SPAN_SHIMS

#include "cdiscord"
#include <lifetimebound.h>
#include <ptrcheck.h>
#include <sys/types.h>

static inline void Discord_ActivityInvite_SetPartyId_Span(Discord_ActivityInvite* self,
                                                          uint8_t *__nullable __counted_by_or_null(size) ptr __noescape,
                                                          size_t size);







// TODO: Figure out how to convert Discord_Properties
// MARK: -  Funcs to convert to a span equivalent.
// MARK: ActivityInvite

void DISCORD_API Discord_ActivityInvite_SetPartyId(Discord_ActivityInvite* self,
                                                   Discord_String value);
void DISCORD_API Discord_ActivityInvite_PartyId(Discord_ActivityInvite* self,
                                                Discord_String* returnValue);
void DISCORD_API Discord_ActivityInvite_SetSessionId(Discord_ActivityInvite* self,
                                                     Discord_String value);
void DISCORD_API Discord_ActivityInvite_SessionId(Discord_ActivityInvite* self,
                                                  Discord_String* returnValue);

// MARK: Activity Assets

void DISCORD_API Discord_ActivityAssets_SetLargeImage(Discord_ActivityAssets* self,
                                                      Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_LargeImage(Discord_ActivityAssets* self,
                                                   Discord_String* returnValue);
void DISCORD_API Discord_ActivityAssets_SetLargeText(Discord_ActivityAssets* self,
                                                     Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_LargeText(Discord_ActivityAssets* self,
                                                  Discord_String* returnValue);
void DISCORD_API Discord_ActivityAssets_SetLargeUrl(Discord_ActivityAssets* self,
                                                    Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_LargeUrl(Discord_ActivityAssets* self,
                                                 Discord_String* returnValue);
void DISCORD_API Discord_ActivityAssets_SetSmallImage(Discord_ActivityAssets* self,
                                                      Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_SmallImage(Discord_ActivityAssets* self,
                                                   Discord_String* returnValue);
void DISCORD_API Discord_ActivityAssets_SetSmallText(Discord_ActivityAssets* self,
                                                     Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_SmallText(Discord_ActivityAssets* self,
                                                  Discord_String* returnValue);
void DISCORD_API Discord_ActivityAssets_SetSmallUrl(Discord_ActivityAssets* self,
                                                    Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_SmallUrl(Discord_ActivityAssets* self,
                                                 Discord_String* returnValue);
void DISCORD_API Discord_ActivityAssets_SetInviteCoverImage(Discord_ActivityAssets* self,
                                                            Discord_String* value);
bool DISCORD_API Discord_ActivityAssets_InviteCoverImage(Discord_ActivityAssets* self,
                                                         Discord_String* returnValue);

// MARK: Activity Party

void DISCORD_API Discord_ActivityParty_SetId(Discord_ActivityParty* self, Discord_String value);
void DISCORD_API Discord_ActivityParty_Id(Discord_ActivityParty* self, Discord_String* returnValue);

// MARK: Activity Secrets

void DISCORD_API Discord_ActivitySecrets_SetJoin(Discord_ActivitySecrets* self,
                                                 Discord_String value);
void DISCORD_API Discord_ActivitySecrets_Join(Discord_ActivitySecrets* self,
                                              Discord_String* returnValue);

// MARK: Activity Button

void DISCORD_API Discord_ActivityButton_SetLabel(Discord_ActivityButton* self,
                                                 Discord_String value);
void DISCORD_API Discord_ActivityButton_Label(Discord_ActivityButton* self,
                                              Discord_String* returnValue);
void DISCORD_API Discord_ActivityButton_SetUrl(Discord_ActivityButton* self, Discord_String value);
void DISCORD_API Discord_ActivityButton_Url(Discord_ActivityButton* self,
                                            Discord_String* returnValue);

// MARK: Activity

void DISCORD_API Discord_Activity_SetName(Discord_Activity* self, Discord_String value);
void DISCORD_API Discord_Activity_Name(Discord_Activity* self, Discord_String* returnValue);
void DISCORD_API Discord_Activity_SetState(Discord_Activity* self, Discord_String* value);
bool DISCORD_API Discord_Activity_State(Discord_Activity* self, Discord_String* returnValue);
void DISCORD_API Discord_Activity_SetStateUrl(Discord_Activity* self, Discord_String* value);
bool DISCORD_API Discord_Activity_StateUrl(Discord_Activity* self, Discord_String* returnValue);
void DISCORD_API Discord_Activity_SetDetails(Discord_Activity* self, Discord_String* value);
bool DISCORD_API Discord_Activity_Details(Discord_Activity* self, Discord_String* returnValue);
void DISCORD_API Discord_Activity_SetDetailsUrl(Discord_Activity* self, Discord_String* value);
bool DISCORD_API Discord_Activity_DetailsUrl(Discord_Activity* self, Discord_String* returnValue);

// MARK: Client Result

void DISCORD_API Discord_ClientResult_ToString(Discord_ClientResult* self,
                                               Discord_String* returnValue);
void DISCORD_API Discord_ClientResult_SetError(Discord_ClientResult* self,
                                               Discord_String value);
void DISCORD_API Discord_ClientResult_Error(Discord_ClientResult* self,
                                            Discord_String* returnValue);
void DISCORD_API Discord_ClientResult_SetResponseBody(Discord_ClientResult* self,
                                                      Discord_String value);
void DISCORD_API Discord_ClientResult_ResponseBody(Discord_ClientResult* self,
                                                   Discord_String* returnValue);

// MARK: Auth Code Challenge

void DISCORD_API
Discord_AuthorizationCodeChallenge_SetChallenge(Discord_AuthorizationCodeChallenge* self,
                                                Discord_String value);
void DISCORD_API
Discord_AuthorizationCodeChallenge_Challenge(Discord_AuthorizationCodeChallenge* self,
                                             Discord_String* returnValue);

// MARK: Auth Code Verifier

void DISCORD_API
Discord_AuthorizationCodeVerifier_SetVerifier(Discord_AuthorizationCodeVerifier* self,
                                              Discord_String value);
void DISCORD_API Discord_AuthorizationCodeVerifier_Verifier(Discord_AuthorizationCodeVerifier* self,
                                                            Discord_String* returnValue);

// MARK: Auth Args

void DISCORD_API Discord_AuthorizationArgs_SetClientId(Discord_AuthorizationArgs* self,
                                                       uint64_t value);
uint64_t DISCORD_API Discord_AuthorizationArgs_ClientId(Discord_AuthorizationArgs* self);
void DISCORD_API Discord_AuthorizationArgs_SetScopes(Discord_AuthorizationArgs* self,
                                                     Discord_String value);
void DISCORD_API Discord_AuthorizationArgs_Scopes(Discord_AuthorizationArgs* self,
                                                  Discord_String* returnValue);
void DISCORD_API Discord_AuthorizationArgs_SetState(Discord_AuthorizationArgs* self,
                                                    Discord_String* value);
bool DISCORD_API Discord_AuthorizationArgs_State(Discord_AuthorizationArgs* self,
                                                 Discord_String* returnValue);
void DISCORD_API Discord_AuthorizationArgs_SetNonce(Discord_AuthorizationArgs* self,
                                                    Discord_String* value);
bool DISCORD_API Discord_AuthorizationArgs_Nonce(Discord_AuthorizationArgs* self,
                                                 Discord_String* returnValue);
void DISCORD_API Discord_AuthorizationArgs_SetCustomSchemeParam(Discord_AuthorizationArgs* self,
                                                                Discord_String* value);
bool DISCORD_API Discord_AuthorizationArgs_CustomSchemeParam(Discord_AuthorizationArgs* self,
                                                             Discord_String* returnValue);

// MARK: Device Auth Args

void DISCORD_API Discord_DeviceAuthorizationArgs_SetScopes(Discord_DeviceAuthorizationArgs* self,
                                                           Discord_String value);
void DISCORD_API Discord_DeviceAuthorizationArgs_Scopes(Discord_DeviceAuthorizationArgs* self,
                                                        Discord_String* returnValue);

// MARK: Call

void DISCORD_API Discord_Call_ErrorToString(Discord_Call_Error type, Discord_String* returnValue);
void DISCORD_API Discord_Call_StatusToString(Discord_Call_Status type, Discord_String* returnValue);

// MARK: Channel Handle

void DISCORD_API Discord_ChannelHandle_Name(Discord_ChannelHandle* self,
                                            Discord_String* returnValue);
void DISCORD_API Discord_ChannelHandle_Recipients(Discord_ChannelHandle* self,
                                                  Discord_UInt64Span* returnValue);

// MARK: Guild Minimal

void DISCORD_API Discord_GuildMinimal_SetName(Discord_GuildMinimal* self, Discord_String value);
void DISCORD_API Discord_GuildMinimal_Name(Discord_GuildMinimal* self, Discord_String* returnValue);

// MARK: Guild Channel

void DISCORD_API Discord_GuildChannel_SetName(Discord_GuildChannel* self, Discord_String value);
void DISCORD_API Discord_GuildChannel_Name(Discord_GuildChannel* self, Discord_String* returnValue);

// MARK: Linked Channel

void DISCORD_API Discord_LinkedChannel_SetName(Discord_LinkedChannel* self, Discord_String value);
void DISCORD_API Discord_LinkedChannel_Name(Discord_LinkedChannel* self,
                                            Discord_String* returnValue);

// MARK: User Application Profile Handle

void DISCORD_API Discord_UserApplicationProfileHandle_AvatarHash(Discord_UserApplicationProfileHandle* self,
                                                                 Discord_String* returnValue);

void DISCORD_API Discord_UserApplicationProfileHandle_Metadata(Discord_UserApplicationProfileHandle* self,
                                                               Discord_String* returnValue);

bool DISCORD_API Discord_UserApplicationProfileHandle_ProviderId(Discord_UserApplicationProfileHandle* self,
                                                                 Discord_String* returnValue);

void DISCORD_API Discord_UserApplicationProfileHandle_ProviderIssuedUserId(Discord_UserApplicationProfileHandle* self,
                                                                           Discord_String* returnValue);

void DISCORD_API Discord_UserApplicationProfileHandle_Username(Discord_UserApplicationProfileHandle* self,
                                                               Discord_String* returnValue);

// MARK: User Handle

bool DISCORD_API Discord_UserHandle_Avatar(Discord_UserHandle* self, Discord_String* returnValue);
void DISCORD_API Discord_UserHandle_AvatarTypeToString(Discord_UserHandle_AvatarType type,
                                                       Discord_String* returnValue);
void DISCORD_API Discord_UserHandle_AvatarUrl(Discord_UserHandle* self,
                                              Discord_UserHandle_AvatarType animatedType,
                                              Discord_UserHandle_AvatarType staticType,
                                              Discord_String* returnValue);
void DISCORD_API Discord_UserHandle_DisplayName(Discord_UserHandle* self,
                                                Discord_String* returnValue);
bool DISCORD_API Discord_UserHandle_GameActivity(Discord_UserHandle* self,
                                                 Discord_Activity* returnValue);
bool DISCORD_API Discord_UserHandle_GlobalName(Discord_UserHandle* self,
                                               Discord_String* returnValue);
void DISCORD_API Discord_UserHandle_Username(Discord_UserHandle* self, Discord_String* returnValue);

// MARK: Additional Content

void DISCORD_API Discord_AdditionalContent_TypeToString(Discord_AdditionalContentType type,
                                                        Discord_String* returnValue);
void DISCORD_API Discord_AdditionalContent_SetTitle(Discord_AdditionalContent* self,
                                                    Discord_String* value);
bool DISCORD_API Discord_AdditionalContent_Title(Discord_AdditionalContent* self,
                                                 Discord_String* returnValue);

// MARK: Message Handle

void DISCORD_API Discord_MessageHandle_Content(Discord_MessageHandle* self,
                                               Discord_String* returnValue);
void DISCORD_API Discord_MessageHandle_RawContent(Discord_MessageHandle* self,
                                                  Discord_String* returnValue);

// MARK: Audio Devices

void DISCORD_API Discord_AudioDevice_SetId(Discord_AudioDevice* self, Discord_String value);
void DISCORD_API Discord_AudioDevice_Id(Discord_AudioDevice* self, Discord_String* returnValue);
void DISCORD_API Discord_AudioDevice_SetName(Discord_AudioDevice* self, Discord_String value);
void DISCORD_API Discord_AudioDevice_Name(Discord_AudioDevice* self, Discord_String* returnValue);

// MARK: Client Create Options

void DISCORD_API Discord_ClientCreateOptions_SetWebBase(Discord_ClientCreateOptions* self,
                                                        Discord_String value);
void DISCORD_API Discord_ClientCreateOptions_WebBase(Discord_ClientCreateOptions* self,
                                                     Discord_String* returnValue);
void DISCORD_API Discord_ClientCreateOptions_SetApiBase(Discord_ClientCreateOptions* self,
                                                        Discord_String value);
void DISCORD_API Discord_ClientCreateOptions_ApiBase(Discord_ClientCreateOptions* self,
                                                     Discord_String* returnValue);

// MARK: Client

void DISCORD_API Discord_Client_ErrorToString(Discord_Client_Error type,
                                              Discord_String* returnValue);
void DISCORD_API Discord_Client_GetDefaultAudioDeviceId(Discord_String* returnValue);
void DISCORD_API Discord_Client_GetDefaultCommunicationScopes(Discord_String* returnValue);
void DISCORD_API Discord_Client_GetDefaultPresenceScopes(Discord_String* returnValue);
void DISCORD_API Discord_Client_GetVersionHash(Discord_String* returnValue);

#endif

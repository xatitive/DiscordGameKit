//
//  DiscordSpan.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

protocol DiscordSpan: DiscordRawObject {
    associatedtype Element

    var ptr: UnsafeMutablePointer<Element>! { get set }
    var size: Int { get set }

    init(ptr: UnsafeMutablePointer<Element>!, size: Int)
}

extension DiscordSpan {
    @inlinable
    consuming func drop() {
        Discord_Free(self.ptr)
    }
}

extension Discord_String: DiscordSpan {}
extension Discord_ActivityButtonSpan: DiscordSpan {}
extension Discord_UInt64Span: DiscordSpan {}
extension Discord_UserApplicationProfileHandleSpan: DiscordSpan {}
extension Discord_LobbyMemberHandleSpan: DiscordSpan {}
extension Discord_CallSpan: DiscordSpan {}
extension Discord_AudioDeviceSpan: DiscordSpan {}
extension Discord_MessageHandleSpan: DiscordSpan {}
extension Discord_UserMessageSummarySpan: DiscordSpan {}
extension Discord_GuildChannelSpan: DiscordSpan {}
extension Discord_GuildMinimalSpan: DiscordSpan {}
extension Discord_RelationshipHandleSpan: DiscordSpan {}
extension Discord_UserHandleSpan: DiscordSpan {}

extension DiscordSpan {
    @inline(__always)
    var isEmpty: Bool { size == 0 }

    @inlinable
    var buffer: UnsafeMutableBufferPointer<Element> {
        UnsafeMutableBufferPointer(start: ptr, count: size)
    }
}

extension DiscordSpan where Element: DiscordRawObject {
    @inline(__always)
    consuming func converting<O: DiscordObject>(_ to: O.Type = O.self) -> [O]
    where O.Object == Element {
        defer { drop() }
        return buffer.compactMap { O(takingOwnership: $0) }
    }
}

extension DiscordSpan where Self == Discord_String {
    @inline(__always)
    consuming func toString() -> String {
        String(discordOwned: self)
    }
}

extension DiscordSpan where Element: FixedWidthInteger {
    @inline(__always)
    consuming func converting() -> [Element] {
        defer { drop() }
        return buffer.compactMap { $0 }
    }
}

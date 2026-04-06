//
//  Box.swift
//  DiscordTry5
//
//  Created by Christian Norton on 3/30/26.
//

@_implementationOnly import discord_partner_sdk

final class CallbackBox<T>: @unchecked Sendable {
    @ThreadSafe var callback: T?
    
    @inlinable
    init(_ callback: T? = nil) {
        self.callback = callback
    }
    
    @inlinable
    func retainedOpaqueValue() -> UnsafeMutableRawPointer {
        return Unmanaged.passRetained(self).toOpaque()
    }
    
    @inlinable
    func unretainedOpaqueValue() -> UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
    
    static func from(opaque: UnsafeMutableRawPointer?, _ as: T.Type = T.self) -> T? {
        guard let opaque else { return nil }
        let box = Unmanaged<CallbackBox<T>>.fromOpaque(opaque).takeUnretainedValue()
        return box.callback
    }
}

func freeBox(_ ptr: UnsafeMutableRawPointer?) {
    guard let ptr else { return }
    Unmanaged<AnyObject>.fromOpaque(ptr).release()
}

func convertRawObject<R: DiscordRawObject, O: DiscordObject>(
    _ raw: R?,
    to obj: O.Type = O.self
) -> O? where R == O.Object {
    guard let raw else { return nil }
    return obj.init(takingOwnership: raw)
}

func convertRawObject<R: DiscordRawObject, O: DiscordObject>(
    _ raw: UnsafeMutablePointer<R>?,
    to obj: O.Type = O.self
) -> O? where R == O.Object {
    guard let raw else { return nil }
    return obj.init(takingOwnership: raw)
}

func convertRawObject<R: DiscordRawObject, O: DiscordObject>(
    _ raw: UnsafePointer<R>?,
    to obj: O.Type = O.self
) -> O? where R == O.Object {
    guard let raw else { return nil }
    return obj.init(takingOwnership: raw)
}

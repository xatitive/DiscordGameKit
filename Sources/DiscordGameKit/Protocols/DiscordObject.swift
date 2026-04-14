//
//  DiscordObject.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 3/20/26.
//

@_implementationOnly import discord_partner_sdk

protocol DiscordObject {
    associatedtype Object: DiscordRawObject
    var storage: DiscordStorage<Object> { get set }
    
    init(storage: DiscordStorage<Object>)
}

extension DiscordObject {
    @inlinable
    init() {
        self.init(storage: .init())
    }
    
    @inlinable
    init(takingOwnership raw: Object) {
        self.init(storage: .init(takingOwnership: raw))
    }
    
    @inlinable
    init?(takingOwnership ptr: UnsafeMutablePointer<Object>?) {
        guard let obj = ptr?.pointee else { return nil }
        self = .init(takingOwnership: obj)
    }
    
    @inlinable
    init?(takingOwnership ptr: UnsafePointer<Object>?) {
        guard let obj = ptr?.pointee else { return nil }
        self = .init(takingOwnership: obj)
    }
    
    @inlinable
    func usingLock<each T, R>(
        _ fn: (UnsafeMutablePointer<Object>, repeat each T) -> R,
        _ args: repeat each T
    ) -> R {
        return storage.withLock { raw in
            return fn(&raw, repeat (each args))
        }
    }
    
    func usingLock<R>(
        _ fn: () -> R
    ) -> R {
        return storage.withLock { raw in
            return fn()
        }
    }
    
    func usingLock<each T, R>(
        _ fn: (repeat each T) -> R,
        _ args: repeat each T
    ) -> R {
        return storage.withLock { raw in
            return fn(repeat (each args))
        }
    }
    
    @inlinable
    func usingLock<R>(
        _ fn: (inout Object) -> R
    ) -> R {
        return storage.withLock { raw in
            return fn(&raw)
        }
    }
    
    func gettingString(
        _ fn: (inout MutableSpan<UInt8>) -> Void
    ) -> String {
        var bytes: InlineArray<1024, UInt8> = .init(repeating: 0)
        var span: MutableSpan<UInt8> = bytes.mutableSpan
        fn(&span)
        return span.toString()
    }
    
    func gettingString(
        _ fn: (inout MutableSpan<UInt8>) -> Bool
    ) -> String? {
        var bytes: InlineArray<1024, UInt8> = .init(repeating: 0)
        var span: MutableSpan<UInt8> = bytes.mutableSpan
        return fn(&span) ? span.toString() : nil
    }

    mutating func settingString(
        _ value: String,
        _ fn: (Span<UInt8>) -> Void,
    ) {
        fn(value.utf8Span.span)
    }
}

extension DiscordObject where Object: DiscordRawCopyable {
    @inlinable
    mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&storage) {
            self.storage = .init(copying: storage)
        }
    }
}

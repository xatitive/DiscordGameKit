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
}

extension DiscordObject where Object: DiscordRawCopyable {
    @inlinable
    mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&storage) {
            self.storage = .init(copying: storage)
        }
    }
}

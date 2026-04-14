//
//  DiscordStorage.swift
//  DiscordGameKit
//
//  Created by Christian Norton on 3/20/26.
//

@_implementationOnly import discord_partner_sdk

final class DiscordStorage<T: DiscordRawObject>: @unchecked Sendable {
    @ThreadSafe fileprivate var raw: T

    @inlinable
    init() {
        raw = T()
    }

    @inlinable
    init(takingOwnership raw: T) {
        self.raw = raw
    }

    @inlinable
    init(copying source: DiscordStorage<T>) where T: DiscordRawCopyable {
        var copy = T()
        source.$raw.withLock { sourceRaw in
            copy = sourceRaw
            sourceRaw.copy(into: &copy)
        }
        self.raw = copy
    }

    @inlinable
    func withLock<R>(_ body: (inout T) throws -> R) rethrows -> R {
        try $raw.withLock(body)
    }

    deinit {
        withLock { $0.drop() }
    }
}

extension DiscordObject {
    var rawObject: Object {
        mutating get { storage.raw }
        set { storage.raw = newValue }
    }
}

func compare<D: DiscordRawObject>(
    _ lhs: DiscordStorage<D>,
    to rhs: DiscordStorage<D>,
    _ fn: (UnsafeMutablePointer<D>?, UnsafeMutablePointer<D>?) -> Bool
) -> Bool {
    let lhsID = ObjectIdentifier(lhs)
    let rhsID = ObjectIdentifier(rhs)

    if lhsID == rhsID {
        // Can't pass the same inout twice — Swift exclusive access will trap
        return lhs.$raw.withLock { raw in
            var copy = raw
            return fn(&raw, &copy)
        }
    }

    let (first, second) = lhsID < rhsID ? (lhs, rhs) : (rhs, lhs)

    return first.$raw.withLock { firstRaw in
        second.$raw.withLock { secondRaw in
            if lhsID < rhsID {
                return fn(&firstRaw, &secondRaw)
            } else {
                return fn(&secondRaw, &firstRaw)
            }
        }
    }
}

func compare<D: DiscordRawObject>(
    _ lhs: DiscordStorage<D>,
    to rhs: DiscordStorage<D>,
    _ fn: (UnsafeMutablePointer<D>?, UnsafePointer<D>?) -> Bool
) -> Bool {
    let lhsID = ObjectIdentifier(lhs)
    let rhsID = ObjectIdentifier(rhs)

    if lhsID == rhsID {
        return lhs.withLock { raw in
            withUnsafePointer(to: raw) { fn(&raw, $0) }
        }
    }

    let (first, second) = lhsID < rhsID ? (lhs, rhs) : (rhs, lhs)
    return first.withLock { firstRaw in
        second.withLock { secondRaw in
            lhsID < rhsID ? fn(&firstRaw, &secondRaw) : fn(&secondRaw, &firstRaw)
        }
    }
}


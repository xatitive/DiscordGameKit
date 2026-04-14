// https://gist.github.com/gdavis/5745bb481af68791bbb8072b9b4a9711
//
//  ThreadSafe.swift
//  GDICore
//
//  Created by Grant Davis on 1/2/21.
//  Updated to support `_modify` accessor on 12/5/21.
//
//  Copyright © 2021 Grant Davis Interactive, LLC. All rights reserved.
//
import Foundation

/// A property wrapper that uses a serial `DispatchQueue` to access the underlying
/// value of the property, and `NSLock` to prevent reading while modifying the value.
///
/// This property wrapper supports mutating properties using coroutines
/// by implementing the `_modify` accessor, which allows the same memory
/// address to be modified serially when accessed from multiple threads.
/// See: https://forums.swift.org/t/modify-accessors/31872
//@propertyWrapper struct ThreadSafe<T> {
//
//    private var _value: T
//    private let lock = NSLock()
//    private let queue: DispatchQueue
//
//    public var wrappedValue: T {
//        get {
//            queue.sync { _value }
//        }
//        _modify {
//            lock.lock()
//            var tmp: T = _value
//
//            defer {
//                _value = tmp
//                lock.unlock()
//            }
//
//            yield &tmp
//        }
//    }
//
//    public var projectedValue: Self {
//        get { self }
//        set { self = newValue }
//    }
//
//    mutating func withLock<R>(_ body: (inout T) throws -> R) rethrows -> R {
//        lock.lock()
//        defer { lock.unlock() }
//        return try body(&_value)
//    }
//
//    init(wrappedValue: T, queue: DispatchQueue? = nil) {
//        self._value = wrappedValue
//        self.queue =
//            queue
//            ?? DispatchQueue(label: "ThreadSafe \(String(typeName: T.self))")
//    }
//}

@propertyWrapper final class ThreadSafe<T> {

    private var _value: T
    private var _lock = os_unfair_lock()

    public var wrappedValue: T {
        get {
            unsafe os_unfair_lock_lock(&_lock)
            defer { unsafe os_unfair_lock_unlock(&_lock) }
            return _value
        }
        _modify {
            unsafe os_unfair_lock_lock(&_lock)
            defer { unsafe os_unfair_lock_unlock(&_lock) }
            yield &_value
        }
    }
    
    public var projectedValue: ThreadSafe<T> { self }

    func withLock<R>(_ body: (inout T) throws -> R) rethrows -> R {
        unsafe os_unfair_lock_lock(&_lock)
        defer { unsafe os_unfair_lock_unlock(&_lock) }
        return try body(&_value)
    }

    init(wrappedValue: T) {
        self._value = wrappedValue
    }
}

// Helper extension to name the queue after the property wrapper's type.
extension String {
    init(typeName thing: Any.Type) {
        let describingString = String(describing: thing)
        let name = describingString.components(separatedBy: ".").last ?? ""

        self.init(stringLiteral: name)
    }
}

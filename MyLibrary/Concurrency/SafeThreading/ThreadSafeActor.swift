//
//  ThreadSafeActor.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 02/05/2024.
//

import Foundation

// The modern counterpart to ThreadSafeWrapper: an actor serializes access to `value` for free,
// with no manual queue/lock needed and no Sendable constraint required on T itself, since only
// one task at a time can ever touch actor-isolated state.
actor ThreadSafeActor<T> {
    private var value: T
    
    init(value: T) {
        self.value = value
    }
    
    func read() -> T {
        print("Read value: \(value)")
        return value
    }
    
    func write(newValue: T) {
        print("Wrote value: \(newValue)")
        value = newValue
    }
}

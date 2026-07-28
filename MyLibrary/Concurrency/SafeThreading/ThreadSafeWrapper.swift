//
//  SafeThreading.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 01/05/2024.
//

import Foundation

/*
 Swift 6 Concurrency:
 - Constrain the generic: T itself must be Sendable, since a T value is literally handed across the queue boundary. No amount of locking around self fixes an unsafe T.
 - Mark the class @unchecked Sendable: the compiler can't understand that the DispatchQueue barrier pattern makes concurrent access to value safe — that's exactly what "unchecked" means here, you're asserting a guarantee the compiler can't verify itself. final is worth adding too, since a subclass could add its own non-locked stored properties and silently break the whole guarantee.
*/
final class ThreadSafeWrapper<T: Sendable>: @unchecked Sendable {
    var value: T
    let queue = DispatchQueue(label: "safeThread", attributes: .concurrent)
    
    init(value: T) {
        self.value = value
    }
    
    func read() -> T {
        var result: T!
        queue.sync {
            result = self.value
            print("Read value: \(self.value)")
        }
        
        return result
    }
    
    func write(newValue: T) {
        queue.async(flags: .barrier) {
            self.value = newValue
            print("Wrote value: \(self.value)")
        }
    }
}

//
//  SafeThreading.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 01/05/2024.
//

import Foundation

class ThreadSafeWrapper<T> {
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

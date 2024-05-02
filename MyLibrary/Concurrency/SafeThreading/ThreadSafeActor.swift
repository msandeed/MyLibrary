//
//  ThreadSafeActor.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 02/05/2024.
//

import Foundation

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

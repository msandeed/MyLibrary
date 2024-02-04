//
//  ObserverPattern.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 21/01/2024.
//

import Foundation
import Combine

// Create a subject that will emit updates
class Subject {
    var value: Int = 0 {
        didSet {
            publisher.send(value)
        }
    }
    
    // Create a Combine subject that emits Int values
    private let publisher = PassthroughSubject<Int, Never>()
    
    // Create a property that exposes the publisher as an AnyPublisher for encapsulation and type-safety
    var valuePublisher: AnyPublisher<Int, Never> {
        return publisher.eraseToAnyPublisher()
    }
}

// Create an observer class
class Observer {
    let name: String
    private var cancellables = Set<AnyCancellable>()
    
    init(name: String) {
        self.name = name
    }
    
    // Subscribe to updates from the subject
    func subscribe(to subject: Subject) {
        subject.valuePublisher
            .sink(receiveValue: { [weak self] value in
                print("\(self?.name ?? "Observer") received update: \(value)")
            })
            .store(in: &cancellables)
    }
}

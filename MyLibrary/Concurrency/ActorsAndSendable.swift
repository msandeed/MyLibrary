//
//  Sendable.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 12/06/2024.
//

// A public API that is safe to use across concurrency domains when there are no public mutators, an internal locking system is in place, or mutators implement copy-on write like with value types.

import Foundation

// MARK: -  Actor + @Sendable

struct Fruit: Equatable {
    let name: String
    let color: String
    let shape: String
}

actor FruitBasket {
    let basketName: String
    let store: String
    var fruits: [Fruit]
    
    init(basketName: String, store: String, fruits: [Fruit] = []) {
        self.basketName = basketName
        self.store = store
        self.fruits = fruits
    }
    
    func addToBasket(_ batch: [Fruit]) {
        fruits.append(contentsOf: batch)
    }
    
    // Computed property does not access any mutable properties. Thus, it's thread-safe. However, we would have to declare that explicitly
    nonisolated var basketFullName: String {
        basketName + " - " + store
    }
    
    // The closure is created by a non-isolated caller but executed here, on the actor's
    // isolated executor, when passed to `contains(where:)`. That crossing is why the
    // parameter must be @Sendable: it lets the compiler verify whatever the closure
    // captures is safe to hand over, rather than just trusting the caller.
    func checkFruit(_ action: @Sendable (Fruit) -> Bool) -> Bool {
        fruits.contains(where: action)
    }
}

class activeSession {
    let fruitBasket: FruitBasket = .init(basketName: "Example", store: "The Store")

    // Crossing into the actor requires await; the call suspends until the actor is free to run it.
    func addToBasket(_ selected: [Fruit]) async {
        await fruitBasket.addToBasket(selected)
    }
    
    func displayBasketFullName() -> String {
        fruitBasket.basketFullName  // No need to await as we're accessing a nonisolated property of the actor
    }
    
    // `fruit` is captured by the closure below and carried into the actor. That capture
    // only compiles because `Fruit` is an implicitly Sendable value type; capturing a
    // non-Sendable reference type, or a mutable local var, here would be a compile error —
    // exactly the check @Sendable exists to run.
    func isFruitInBasket(_ fruit: Fruit) async -> Bool {
        await fruitBasket.checkFruit { candidate in
            candidate == fruit
        }
    }
}

// MARK: - Sendable protocol

// Implicitly conforms to Sendable
struct User {
    var name: String
}

// Article is final and immutable and therefore it is thread-safe. However, we would have to manually indicate conformance to Sendable
final class Article: Sendable {
    let name: String = ""
}


// Since MutableUser has internal locking mechanism making it thread-safe, we would add @unchecked Sendable to indicate to the compiler that we can assure thread-safety
extension DispatchQueue {
    static let userMutatingLock = DispatchQueue(label: "person.lock.queue")
}

final class MutableUser: @unchecked Sendable {
    private var name: String = ""

    func updateName(_ name: String) {
        DispatchQueue.userMutatingLock.sync {
            self.name = name
        }
    }
}

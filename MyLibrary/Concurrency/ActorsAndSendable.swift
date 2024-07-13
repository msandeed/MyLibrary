//
//  Sendable.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 12/06/2024.
//

// A public API is safe to use across concurrency domains when there are no public mutators, an internal locking system is in place, or mutators implement copy-on write like with value types.

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
    
    // When passing a function into an actor-isolated context, we have to declare that it's thread-safe using @Sendable attribute
    func checkFruit(_ action: @Sendable (Fruit) -> Bool) { }
}

class activeSession {
    let fruitBasket: FruitBasket = .init(basketName: "Example", store: "The Store")
    
    func addToBasket(_ selected: [Fruit]) async {
        await fruitBasket.addToBasket(selected)
    }
    
    func displayBasketFullName() -> String {
        fruitBasket.basketFullName  // No need to await as we're accessing a nonisolated property of the actor
    }
    
    func isFruitInBasket(_ fruit: Fruit) async {
        await fruitBasket.checkFruit { fruit in
            return true
        }
    }
}

// MARK: - Sendable protocol

// Implicitly conforms to Sendable
struct User {
    var name: String
}

// Article is final and immutable and therefore it is thread-safe. However, we would have to manually indicate conformance ot Sendable
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

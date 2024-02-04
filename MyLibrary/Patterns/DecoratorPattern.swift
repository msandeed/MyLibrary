//
//  DecoratorPattern.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 21/01/2024.
//

import Foundation

// Component: Pizza
protocol Pizza {
    func cost() -> Double
    func description() -> String
}

// Concrete Component: BasicPizza
class BasicPizza: Pizza {
    func cost() -> Double {
        return 5.0
    }
    
    func description() -> String {
        return "Basic Pizza"
    }
}

// Decorator: ToppingDecorator
class ToppingDecorator: Pizza {
    private let wrappedPizza: Pizza
    
    init(_ pizza: Pizza) {
        self.wrappedPizza = pizza
    }
    
    func cost() -> Double {
        return wrappedPizza.cost()
    }
    
    func description() -> String {
        return wrappedPizza.description()
    }
}

// Concrete Decorator: CheeseTopping
class CheeseTopping: ToppingDecorator {
    override func cost() -> Double {
        return super.cost() + 1.0
    }
    
    override func description() -> String {
        return super.description() + " with Cheese"
    }
}

// Concrete Decorator: PepperoniTopping
class PepperoniTopping: ToppingDecorator {
    override func cost() -> Double {
        return super.cost() + 1.5
    }
    
    override func description() -> String {
        return super.description() + " with Pepperoni"
    }
}

// Usage example
//let basicPizza: Pizza = BasicPizza()
//print("Basic Pizza: \(basicPizza.description()) - Cost: $\(basicPizza.cost())")
//
//let cheesePizza: Pizza = CheeseTopping(basicPizza)
//print("Cheese Pizza: \(cheesePizza.description()) - Cost: $\(cheesePizza.cost())")
//
//let pepperoniPizza: Pizza = PepperoniTopping(basicPizza)
//print("Pepperoni Pizza: \(pepperoniPizza.description()) - Cost: $\(pepperoniPizza.cost())")
//
//let deluxePizza: Pizza = PepperoniTopping(CheeseTopping(basicPizza))
//print("Deluxe Pizza: \(deluxePizza.description()) - Cost: $\(deluxePizza.cost())")

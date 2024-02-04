//
//  FactoryPattern.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 21/01/2024.
//

import Foundation

//MARK: - PRODUCT
protocol AbstractProduct {
    func display()
}

class ConcreteProductA: AbstractProduct {
    func display() {
        print("Product A Displayed")
    }
}

class ConcreteProductB: AbstractProduct {
    func display() {
        print("Product B Displayed")
    }
}

//MARK: - Dispatcher
protocol AbstractDispatcher {
    func produce() -> AbstractProduct
}

class ConcreteDispatcherA: AbstractDispatcher {
    func produce() -> AbstractProduct {
        print("Product A Dispatched")
        return ConcreteProductA.init()
    }
}

class ConcreteDispatcherB: AbstractDispatcher {
    func produce() -> AbstractProduct {
        print("Product B Dispatched")
        return ConcreteProductB.init()
    }
}

//* Other ones to come

// Singleton Pattern

// Coordinator for Navigation

//*

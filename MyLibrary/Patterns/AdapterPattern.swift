//
//  AdapterPattern.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 12/02/2024.
//

import Foundation

// Existing class with a specific interface
class LegacyService {
    func performOldAction() {
        print("Legacy action performed")
    }
}

// Target interface that we want to use
protocol NewService {
    func performNewAction()
}

// Adapter to use LegacyService via NewService
class LegacyServiceAdapter: NewService {
    private let legacyService: LegacyService
    
    init(legacyService: LegacyService) {
        self.legacyService = legacyService
    }
    
    func performNewAction() {
        legacyService.performOldAction()
    }
}

// Client code using the NewService interface
class Client {
    let newService: NewService
    
    init(newService: NewService) {
        self.newService = newService
    }
    
    func doSomething() {
        newService.performNewAction()
    }
}

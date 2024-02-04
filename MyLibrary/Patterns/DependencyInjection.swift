//
//  DependencyInjection.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 21/01/2024.
//

import Foundation

class ConsumerViewModel {
    private let dispatcher: AbstractDispatcher
    
    init(dispatcher: AbstractDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func getNewProduct() {
        let product = dispatcher.produce()
        product.display()
    }
}

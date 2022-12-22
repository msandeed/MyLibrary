//
//  ViewModelType.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/12/2022.
//

import Foundation
import Combine

protocol ViewModelType: ObservableObject where Output: ObservableObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    var subscriptions: [AnyCancellable] { get }
    
    func observeInputs()
}

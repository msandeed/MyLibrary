//
//  MementoPattern.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 12/02/2024.
//

import Foundation

// Originator: Object whose state needs to be saved
class TextEditor {
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
    // Create a Memento with the current state
    func createMemento() -> TextEditorMemento {
        return TextEditorMemento(text: text)
    }
    
    // Restore the state from a Memento
    func restore(from memento: TextEditorMemento) {
        text = memento.text
    }
    
    func printText() {
        print("Current Text: \(text)")
    }
}

// Memento: Object that stores the state of the Originator
class TextEditorMemento {
    let text: String
    
    init(text: String) {
        self.text = text
    }
}

// Caretaker: Manages and keeps track of multiple Mementos
class TextEditorHistory {
    var mementos: [TextEditorMemento] = []
    
    func addMemento(_ memento: TextEditorMemento) {
        mementos.append(memento)
    }
    
    func getMemento(at index: Int) -> TextEditorMemento? {
        guard index >= 0, index < mementos.count else {
            return nil
        }
        return mementos[index]
    }
}

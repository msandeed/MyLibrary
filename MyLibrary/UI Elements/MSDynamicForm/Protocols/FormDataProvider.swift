//
//  FormDataProvider.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 23/03/2026.
//

import Foundation

protocol FormDataProvider {
    func fetchOptions(for fieldID: String) async throws -> [FormOption]
}

struct DefaultFormDataProvider: FormDataProvider {
    func fetchOptions(for fieldID: String) async throws -> [FormOption] {
        switch fieldID {
        case "gender":
            return ["Male", "Female"].map(map)

        case "hobbies":
            return ["Reading", "Tennis", "Hiking", "Coding"].map(map)

        case "country":
            return ["Egypt", "USA", "Germany", "France", "Spain", "Japan", "Italy", "Brazil", "Canada", "Australia", "New Zealand"].map(map)

        default:
            return []
        }
    }
    
    private func map(_ title: String) -> FormOption {
        .init(id: UUID().uuidString, title: title)
    }
}

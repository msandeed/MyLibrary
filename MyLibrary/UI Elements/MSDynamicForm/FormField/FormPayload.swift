//
//  FormPayload.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 23/03/2026.
//

import Foundation

struct FormPayload: Encodable {
    let values: [String: Value]

    enum Value: Encodable {
        case string(String)
        case array([String])

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            }
        }
    }
    
    var printableValue: String {
        let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            do {
                let data = try encoder.encode(values) // Encode dictionary directly
                return String(data: data, encoding: .utf8) ?? "Invalid encoding"
            } catch {
                return "Encoding error: \(error.localizedDescription)"
            }
    }
}

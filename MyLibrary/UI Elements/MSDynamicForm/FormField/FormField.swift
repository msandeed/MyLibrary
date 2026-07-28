//
//  FormField.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/03/2026.
//

import Foundation

enum FormFieldType {
    case text
    case singleChoice
    case multipleChoice
    case dropdown
    case date
    case dateAndTime
}

struct FormField: Identifiable, Equatable {
    let id: String
    let title: String
    let type: FormFieldType
    let isRequired: Bool
    var isLoadingOptions: Bool = false
    var isVisible: Bool = true
    
    // Dynamic data (from API)
    var options: [FormOption] = []
    
    // User input
    var textValue: String = ""
    var dateValue: Date = Date()
    var selectedOption: FormOption? = nil
    var selectedOptions: Set<FormOption> = []
}

extension FormField: FormFieldValueConvertible {
    func toPayloadValue() -> FormPayload.Value? {
        switch type {
        case .text:
            return .string(textValue)
        case .singleChoice, .dropdown:
            return selectedOption.map { .string($0.title) }
        case .multipleChoice:
            return .array(selectedOptions.map { $0.title })
        case .date, .dateAndTime:
            return .string(formatUTC(dateValue))
        }
    }
    
    private func formatUTC(_ date: Date) -> String {
        isoFormatter().string(from: date)
    }
    
    private func isoFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [
            .withInternetDateTime
        ]
        return formatter
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
}

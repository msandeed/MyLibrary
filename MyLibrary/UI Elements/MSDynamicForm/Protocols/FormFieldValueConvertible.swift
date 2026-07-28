//
//  FormFieldValueConvertible.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 23/03/2026.
//

protocol FormFieldValueConvertible {
    var id: String { get }
    func toPayloadValue() -> FormPayload.Value?
}

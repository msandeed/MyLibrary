//
//  MSDynamicFormViewModel.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/03/2026.
//

import Foundation
import Combine

@MainActor
class MSDynamicFormViewModel: ObservableObject {
    @Published var payload: FormPayload?
    @Published var fields: [FormField] = []
    private let dataProvider: FormDataProvider
    
    var cancellables = Set<AnyCancellable>()
    
    init(fields: [FormField], dataProvider: FormDataProvider = DefaultFormDataProvider())
    {
        self.fields = fields
        self.dataProvider = dataProvider
    }
    
    func loadData() async {
        await withTaskGroup(of: (String, [FormOption]).self) { group in
            
            for field in fields {
                group.addTask {
                    let options = (try? await self.dataProvider.fetchOptions(for: field.id)) ?? []
                    return (field.id, options)
                }
            }
            
            for await (id, options) in group {
                injectOptions(id: id, options: options)
            }
        }
    }
    
    private func injectOptions(id: String, options: [FormOption]) {
        guard let index = fields.firstIndex(where: { $0.id == id }) else { return }
        fields[index].options = options
    }
    
    func buildPayload() {
        let dict = fields.reduce(into: [String: FormPayload.Value]()) { result, field in
            if let value = field.toPayloadValue() {
                result[field.id] = value
            }
        }

        payload = FormPayload(values: dict)
    }
}

extension MSDynamicFormViewModel {
    func publisher(for fieldID: String) -> AnyPublisher<FormField, Never> {
        $fields
            .compactMap { fields in
                fields.first(where: { $0.id == fieldID })
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

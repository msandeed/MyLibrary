//
//  MSDynamicForm.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/03/2026.
//

import Combine
import SwiftUI

struct MSDynamicForm: View {
    @ObservedObject var vm: MSDynamicFormViewModel
    
    init(vm: MSDynamicFormViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Form {
                ForEach($vm.fields) { $field in
                    Section(header: Text(field.title)) {
                        FieldRenderer(field: $field)
                            .onChange(of: field.textValue) { _ in
                                vm.buildPayload()
                            }
                            .onChange(of: field.selectedOption) { _ in
                                vm.buildPayload()
                            }
                            .onChange(of: field.selectedOptions) { _ in
                                vm.buildPayload()
                            }
                            .onChange(of: field.dateValue) { _ in
                                vm.buildPayload()
                            }
                    }
                }
            }
            .task {
                await vm.loadData()
            }
        }
    }
}

struct FieldRenderer: View {
    @Binding var field: FormField
    
    var body: some View {
        switch field.type {
        case .text:
            TextField("Enter \(field.title)", text: $field.textValue)
        case .singleChoice:
            ForEach(field.options, id: \.self) { option in
                HStack {
                    Text(option.title)
                    Spacer()
                    if field.selectedOption == option {
                        Image(systemName: "checkmark")
                    }
                }
                .onTapGesture {
                    field.selectedOption = option
                }
            }
        case .multipleChoice:
            ForEach(field.options, id: \.self) { option in
                HStack {
                    Text(option.title)
                    Spacer()
                    Image(systemName:
                            field.selectedOptions.contains(option)
                          ? "checkmark.square"
                          : "square"
                    )
                }
                .onTapGesture {
                    if field.selectedOptions.contains(option) {
                        field.selectedOptions.remove(option)
                    } else {
                        field.selectedOptions.insert(option)
                    }
                }
            }
        case .dropdown:
            Picker("Select", selection: $field.selectedOption) {
                Text("").tag(Optional<FormOption>.none) // nil case
                ForEach(field.options, id: \.id) { option in
                    Text(option.title).tag(Optional(option))
                }
            }
        case .date:
            DatePicker(
                field.title,
                selection: $field.dateValue,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
        case .dateAndTime:
            DatePicker(
                field.title,
                selection: $field.dateValue,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
        }
    }
}

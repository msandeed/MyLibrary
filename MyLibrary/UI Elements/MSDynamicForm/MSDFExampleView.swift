//
//  MSDFExampleView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 22/03/2026.
//

import SwiftUI

struct MSDFExampleView: View {
    @ObservedObject var vm: MSDFExampleViewModel = .init(fields: [
        FormField(id: "name", title: "Name", type: .text, isRequired: true),
        FormField(id: "gender", title: "Gender", type: .singleChoice, isRequired: true),
        FormField(id: "hobbies", title: "Hobbies", type: .multipleChoice, isRequired: false),
        FormField(id: "country", title: "Country", type: .dropdown, isRequired: true),
        FormField(id: "date", title: "Date", type: .date, isRequired: true),
        FormField(id: "dateAndTime", title: "Date and Time", type: .dateAndTime, isRequired: true)
    ])
    
    var body: some View {
        VStack {
            MSDynamicForm(vm: vm)
            
            if let payload = vm.payload {
                Text(payload.printableValue)
            }
            
            Spacer()
        }
    }
}

class MSDFExampleViewModel: MSDynamicFormViewModel {
    override init(fields: [FormField], dataProvider: any FormDataProvider = DefaultFormDataProvider()) {
        super.init(fields: fields, dataProvider: dataProvider)
        
        followFields()
    }
    
    private func followFields() {
        let genderField = publisher(for: "gender")
        
        genderField
            .sink { [weak self] field in
                guard let self else { return }
                
                print("Gender changed:", field.selectedOption?.title ?? "")
                
                if field.selectedOption?.title == "Male" {
                    // do something
                }
            }
            .store(in: &cancellables)
    }
}

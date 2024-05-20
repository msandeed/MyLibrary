//
//  FormalGroupBox.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 20/05/2024.
//

import SwiftUI

struct FormalGroupBox: View {
    @State var title: String
    @State var contentWording: String
    @State var atAccept: () -> ()
    
    var body: some View {
        GroupBox {
            ScrollView(.vertical) {
                Text(contentWording)
                    .font(.footnote)
            }
            .padding(8)
            .frame(maxHeight: 300)
            .background(.thinMaterial)
            HStack(spacing: 4) {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                Text("Accept")
                    .fontWeight(.medium)
            }
            .foregroundStyle(Color.netflixDarkGray)
            .onTapGesture {
                atAccept()
            }
        } label: {
            Label(title, systemImage: "building.columns")
        }
        .groupBoxStyle(.themed)
        .padding()
    }
}

#Preview {
    FormalGroupBox(title: "Terms and Conditions", 
                   contentWording: "Acceptance of Terms: By accessing or using our services, you agree to be bound by these terms. \n\nModification of Terms: We reserve the right to modify these terms at any time without prior notice.\n\nUser Conduct: Users must use the service in compliance with all applicable laws and regulations. \n\nLimitation of Liability: We are not liable for any damages arising from the use of our services. \n\nTermination: We may terminate or suspend access to our services immediately, without prior notice or liability, for any reason.") {
        print("User Accepted")
    }
}

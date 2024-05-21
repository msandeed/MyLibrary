//
//  ReminderGroupBox.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 20/05/2024.
//

import SwiftUI

struct ReminderGroupBox: View {
    @State var title: String
    @State var subtitle: String = ""
    @State var description: String = ""
    @State var atDone: () -> ()
    @State var atSkip: () -> ()
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 16) {
                // Info
                VStack(alignment: .leading) {
                    Text(subtitle)
                        .fontWeight(.medium)
                    Text(description)
                        .fontWeight(.light)
                }
                
                Rectangle()
                    .foregroundStyle(Color.netflixDarkGray)
                    .frame(height: 1)
                
                // Controls
                HStack(spacing: 16) {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "xmark")
                        Text("Skip")
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(Color.netflixDarkGray)
                    .onTapGesture {
                        atSkip()
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                        Text("Done")
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(Color.netflixDarkGray)
                    .onTapGesture {
                        atDone()
                    }
                    Spacer()
                }
            }
        } label: {
            Label(title, systemImage: "bell")
        }
        .groupBoxStyle(.themed)
        .padding()
    }
}

#Preview {
    VStack {
        ReminderGroupBox(title: "Permadol",
                         subtitle: "150mg, 1 capsule",
                         description: "After breakfast") {
            print("Done")
        } atSkip: {
            print("Skip")
        }
        
        ReminderGroupBox(title: "Piano lesson",
                         subtitle: "Wed, 12",
                         description: "Für Elise") {
            print("Done")
        } atSkip: {
            print("Skip")
        }
        
        ReminderGroupBox(title: "Test case",
                         subtitle: "Pointless long subtitle for no apparent reason",
                         description: "An understandably long description of maybe multilines.") {
            print("Done")
        } atSkip: {
            print("Skip")
        }
    }
}


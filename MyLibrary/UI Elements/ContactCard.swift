//
//  ContactCard.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 29/11/2023.
//

import SwiftUI

enum ContactCardStyle {
    case selectable, compressed
}

struct ContactCard: View {
    var style: ContactCardStyle
    var title: String
    var subtitle: String
    @Binding var isSelected: Bool
    @State var selected: Bool = false {
        didSet {
            isSelected = selected
        }
    }
    
    var body: some View {
        HStack {
            HStack {
                HeadshotView(imageName: "person",
                             diameter: style == .selectable ? 48 : 64)
                Text(title)
                    .font(Font.header2)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            if style == .selectable {
                checkmarkCircle()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 80)
        .frame(width: style == .selectable ? .infinity : Constants.width * 0.65)
        .background(RoundedShadowView(cornerRadius: style == .selectable ? 16 : 24))
        .padding(16)
    }
    
    @ViewBuilder func checkmarkCircle() -> some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                Button {
                    selected.toggle()
                } label: {
                    Image("checkmark")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .padding(Padding.micro)
                }
            }
            .frame(width: 36, height: 36, alignment: .center)
            .background(selected ? Color("purple") : .white)
            .cornerRadius(18)
            .overlay(
                Circle()
                    .stroke(selected ? Color.clear : Color(hex: "#8D8D92"), lineWidth: 1)
                    .frame(width: 36, height: 36)
            )
        }
    }
}

struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        ContactCard(style: .compressed, title: "John Applessed", subtitle: "+1123123123", isSelected: .constant(true))
    }
}



struct RoundedShadowView: View {
    let cornerRadius: Double
    let minHeight: Double
    
    init(cornerRadius: Double = Radius.medium, minHeight: Double = 47) {
        self.cornerRadius = cornerRadius
        self.minHeight = minHeight
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.1),
                    radius: 2, x: 0, y: 1)
    }
}

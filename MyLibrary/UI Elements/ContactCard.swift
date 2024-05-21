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
    var subtitle: String?
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            HStack {
                HeadshotView(imageName: "person",
                             diameter: style == .selectable ? 48 : 64)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    if let subtitleText = subtitle {
                        Text(subtitleText)
                            .font(.footnote)
                            .foregroundColor(Color.netflixDarkGray)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
            }
            
            Spacer()
            
            if style == .selectable {
                checkmarkCircle()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 80)
        .frame(maxWidth: style == .selectable ? .infinity : Constants.width * 0.65)
        .background(RoundedShadowView(cornerRadius: style == .selectable ? 16 : 24))
        .padding(16)
    }
    
    @ViewBuilder func checkmarkCircle() -> some View {
        ZStack {
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "checkmark")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 16)
                    .foregroundColor(.white)
                    .padding(Padding.micro)
            }
            .frame(width: 36, height: 36, alignment: .center)
            .background(isSelected ? Color.blue : .white)
            .cornerRadius(18)
            .overlay(
                Circle()
                    .stroke(isSelected ? Color.clear : Color(hex: "#8D8D92"), lineWidth: 1)
                    .frame(width: 36, height: 36)
            )
            .onTapGesture {
                isSelected.toggle()
                print(isSelected)
            }
        }
    }
}

struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        @State var isSelected: Bool = false
        ContactCard(style: .selectable, title: "John Applessed", subtitle: "+1123123123", isSelected: $isSelected)
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

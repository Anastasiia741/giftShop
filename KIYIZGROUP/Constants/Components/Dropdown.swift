//  Dropdown.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 22/1/25.

import SwiftUI

struct Dropdown: View {
    private let textComponent = TextComponent()
    var borderColor: Color = .gray
    let placeholder: String
    let options: [String]
    @Binding var selectedOption: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    textComponent.createText(text: selectedOption.isEmpty ? placeholder : selectedOption, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1.3))
            }
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                textComponent.createText(text: option, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                                Spacer()
                            }
                            .padding()
                        }
                        if option != options.last {
                            CustomDivider()
                        }
                    }
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1.3))
                .padding(.top, 8)
            }
        }
    }
}

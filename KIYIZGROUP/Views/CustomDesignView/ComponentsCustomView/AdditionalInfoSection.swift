//  AdditionalInfoSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI

struct AdditionalInfoSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    @State private var additionalText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textComponent.createText(text: "Дополнительно", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.bottom, 4)
            
            ZStack(alignment: .topLeading) {
                if additionalText.isEmpty {
                    textComponent.createText(text: "Напишите, чтобы вы хотели разместить на товаре", fontSize: 16, fontWeight: .regular, color: .gray)
                }
            
                TextEditor(text: $additionalText)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.top, 4)
                    .foregroundColor(additionalText.isEmpty ? .gray : .primary)
            }
            .frame(height: 72)
        }
    }
}

//  AdditionalInfoSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI

struct AdditionalInfoSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    @Binding var additionalText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textComponent.createText(text: "Дополнительно", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.bottom, 4)
            textComponent.createText(text: "Напишите, чтобы вы хотели разместить на товаре", fontSize: 12, fontWeight: .regular, color: .gray)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $additionalText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .background(Color.clear)
            }
            .frame(height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

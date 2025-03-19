//  AdditionalInfoSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI

struct AdditionalInfoSection: View {
    private let textComponent = TextComponent()
    @Binding var additionalText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textComponent.createText(text: "additionally".localized, fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                .padding(.bottom, 4)
            textComponent.createText(text: "write_what_you_would_like".localized, fontSize: 12, fontWeight: .regular, lightColor: .gray, darkColor: .white)
            
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

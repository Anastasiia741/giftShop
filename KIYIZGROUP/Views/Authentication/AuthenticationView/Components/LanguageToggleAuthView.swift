//  HeaderAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct LanguageToggleAuthView: View {
    private let textComponent = TextComponent()
    let availableLanguages: [String]
    @Binding var selectedLanguage: String
    
    var body: some View {
        Button(action: {
            toggleLanguage()
        }) {
            textComponent.createText(text: selectedLanguage, fontSize: 16, fontWeight: .regular, lightColor: .colorLightBrown, darkColor: .colorLightBrown)
        }
    }
    
    private func toggleLanguage() {
        if let currentIndex = availableLanguages.firstIndex(of: selectedLanguage) {
            let nextIndex = (currentIndex + 1) % availableLanguages.count
            selectedLanguage = availableLanguages[nextIndex]
        }
    }
}

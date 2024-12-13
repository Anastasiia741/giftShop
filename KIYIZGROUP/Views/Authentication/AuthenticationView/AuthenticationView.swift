//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedLanguage = "EN"
    private let availableLanguages = ["EN", "KG", "РУ"]
    var onAuthenticationSuccess: (String) -> Void
    var onRegistrationSuccess: () -> Void
    
    var body: some View {
        NavigationView {
            VStack() {
                Spacer()
                HeaderAuthView()
                Spacer()
                ImageGridAuthView(imageNames: ["image1","image2","image3","image4","image5","image6","image7","image8","image9"])
                Spacer()
                ButtonsAuthView(onAuthenticationSuccess: onAuthenticationSuccess,
                                onRegistrationSuccess: onRegistrationSuccess)
                .padding(.vertical)
            }
            .navigationBarItems(trailing: LanguageToggleAuthView(availableLanguages: availableLanguages, selectedLanguage: $selectedLanguage)
                .padding(.horizontal))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

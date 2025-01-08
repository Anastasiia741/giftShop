//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth


struct AuthenticationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedLanguage = "EN"
    private let availableLanguages = ["EN", "KG", "РУ"]
    @State private var activeScreen: ActiveScreen? = nil
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HeaderAuthView()
                Spacer()
                ImageGridAuthView(imageNames: ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9"])
                Spacer()
                ButtonsAuthView(onButtonTap: { screen in
                    withAnimation {
                        activeScreen = screen
                    }
                })
                .padding(.vertical)
            }
            .onTapGesture {
                self.hideKeyboard()
                UIApplication.shared.endEditing()
            }
            .overlay(
                HStack {
                    Spacer()
                    LanguageToggleAuthView(availableLanguages: availableLanguages, selectedLanguage: $selectedLanguage)
                        .padding(.horizontal)
                }
                    .padding()
                    .frame(maxHeight: 44),
                alignment: .topTrailing
            )
            if activeScreen == .registration {
                RegistrationView(onBack: {
                    withAnimation {
                        activeScreen = nil
                    }
                })
                .customTransition(isPresented: $activeScreen)
            }
            if activeScreen == .authorization {
                AuthorizationView(onBack: {
                    withAnimation {
                        activeScreen = nil
                    }
                })
                .customTransition(isPresented: $activeScreen)
            }
            
        }
    }
}

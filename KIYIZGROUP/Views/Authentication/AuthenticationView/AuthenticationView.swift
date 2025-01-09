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
                ImageGridAuthView(imageNames: ["Frame 59", "Frame 60", "Frame 61", "Frame 62", "Frame 63", "Frame 64", "Frame 65", "Frame 66", "Frame 67"])
                Spacer()
                HeaderAuthView()
                .padding()
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

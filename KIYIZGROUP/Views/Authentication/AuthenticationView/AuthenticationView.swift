//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @State private var selectedLanguage = "EN"
    @State private var activeScreen: ActiveScreen? = nil
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ImageGridAuthView(imageNames: AuthImages.imageNames)
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
            .navigationDestination(item: $activeScreen) { screen in
                switch screen {
                case .registration:
                    RegistrationView(currentTab: $currentTab)
                case .authorization:
                    AuthorizationView(currentTab: $currentTab)
                }
            }
            .overlay(HStack {
                Spacer()
                LanguageToggleAuthView(availableLanguages: LanguageOptions.available, selectedLanguage: $selectedLanguage)
                    .padding(.horizontal)
            }
                .padding()
                .frame(maxHeight: 44), alignment: .topTrailing)
        }
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
    }
}


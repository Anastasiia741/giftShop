//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedLanguage = "EN"
    @State private var activeScreen: ActiveScreen? = nil
    
    var body: some View {
        CustomNavigation(isActive: Binding(
            get: { activeScreen != nil },
            set: { newValue in
                if !newValue {
                    activeScreen = nil
                }
            }
        ),
                         showBackButton: true,
                         destination: {
            switch activeScreen {
            case .registration:
                RegistrationView()
            case .authorization:
                AuthorizationView()
            case .none:
                EmptyView()
            }
        },
                         content: {
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
            .overlay(HStack {
                Spacer()
                LanguageToggleAuthView(availableLanguages: LanguageOptions.available, selectedLanguage: $selectedLanguage)
                    .padding(.horizontal)
            }
                .padding()
                .frame(maxHeight: 44),
                     alignment: .topTrailing
            )
        }
        )
    }
}

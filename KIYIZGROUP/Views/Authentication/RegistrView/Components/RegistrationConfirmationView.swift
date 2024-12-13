//  RegistrationConfirmationView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct RegistrationConfirmationView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = AuthenticationVM()
    private let textComponent = TextComponent()
    var email: String
    var onAuthenticationSuccess: (String) -> Void
    @State private var navigateToAuthView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    textComponent.createText(text: "Поздравляем! Вы успешно зарегистрировались.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
        
                    textComponent.createText(text: "Завершите авторизацию, чтобы получить доступ к вашему аккаунту.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                Spacer()
                VStack(spacing: 16) {
                    Button(action: {
                        navigateToAuthView = true
                    }) {
                        textComponent.createText(text: "Войти", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.colorLightBrown, lineWidth: 1.3)
                            )
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.bottom, 32)
            }
            .navigationDestination(isPresented: $navigateToAuthView) {
                AuthorizationView(onAuthenticationSuccess: onAuthenticationSuccess)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}



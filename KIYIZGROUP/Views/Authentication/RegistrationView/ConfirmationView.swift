//  RegistrationConfirmationView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct ConfirmationView: View {
    @Environment(\.colorScheme) var colorScheme
    let customButton: CustomButton
    let email: String
    private let textComponent = TextComponent()
    @Binding var currentTab: Int
    @State private var isShowAuthView = false
    
    var body: some View {
        VStack {
            VStack{
                Spacer()
                textComponent.createText(text: "Поздравляем!", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .padding(.vertical)
                
                textComponent.createText(text: "\(email) успешно зарегистрирован.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .padding(.vertical)
                
                textComponent.createText(text: "Завершите авторизацию, чтобы получить доступ к вашему аккаунту.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .padding(.vertical)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            VStack(spacing: 16) {
                customButton.createButton(text: "Войти", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black, backgroundColor: .clear, borderColor: .colorDarkBrown,action: {
                    isShowAuthView = true
                })
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
            }
            .navigationDestination(isPresented: $isShowAuthView) {
                AuthorizationView(currentTab: $currentTab)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

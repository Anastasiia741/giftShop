//  ButtonsAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct ButtonsAuthView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    var onAuthenticationSuccess: ((String) -> Void)

    var body: some View {
        HStack(spacing: 16) {
          
                NavigationLink(destination: RegistrView()) {
                    textComponent.createText(text: "Регистрация", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity, maxHeight: 54)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.colorDarkBrown, lineWidth: 1)
                        )
                }
            
            NavigationLink(destination: AuthView(onAuthenticationSuccess: onAuthenticationSuccess)) {
                textComponent.createText(text: "Войти", fontSize: 16, fontWeight: .regular, color: .white)
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .background(Color.colorGreen)
                    .cornerRadius(40)
            }
        }
        .frame(height: 54)
        .padding([.horizontal,.vertical])
    }
}


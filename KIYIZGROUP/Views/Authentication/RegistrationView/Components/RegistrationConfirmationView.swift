//  RegistrationConfirmationView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct RegistrationConfirmationView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = RegistrationVM()
    private let textComponent = TextComponent()
    let customButton: CustomButton
    @State private var navigateToAuthView = false
    
    var body: some View {
        CustomNavigationView(
            isActive: $navigateToAuthView,
            destination: {
                AuthorizationView()
            },
            content: {
                VStack {
                    Spacer()
                    textComponent.createText(text: "Поздравляем! Вы успешно зарегистрировались.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    textComponent.createText(text: "Завершите авторизацию, чтобы получить доступ к вашему аккаунту.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Spacer()
                    VStack(spacing: 16) {
                        customButton.createButton(text: "Войти", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black, backgroundColor: .clear, borderColor: .colorDarkBrown,action: {
                            navigateToAuthView = true
                        })
                        .padding(.horizontal, 32)
                    }
                }
            }
        )
    }
}

struct RegistrationConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationConfirmationView(
            customButton: CustomButton()
            
        )
        .environment(\.colorScheme, .light)
        .previewDisplayName("Light Mode")
        
        RegistrationConfirmationView(
            customButton: CustomButton()
        )
        .environment(\.colorScheme, .dark)
        .previewDisplayName("Dark Mode")
    }
}

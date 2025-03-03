//  ButtonsAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

enum ActiveScreen: Identifiable, Equatable {
    case registration
    case authorization
    
    var id: String {
        switch self {
        case .registration: return "registration"
        case .authorization: return "authorization"
        }
    }
}

struct ButtonsAuthView: View {
//    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    var onButtonTap: (ActiveScreen) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation {
                    onButtonTap(.registration)
                }
            }) {
                textComponent.createText(text: "Регистрация", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.colorDarkBrown, lineWidth: 1)
                    )
            }
            Button(action: {
                withAnimation {
                    onButtonTap(.authorization)
                }
            }) {
                textComponent.createText(text: "Войти", fontSize: 16, fontWeight: .regular, lightColor: .white, darkColor: .white)
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: 54)
                    .background(.colorGreen)
                    .cornerRadius(40)
            }
        }
        .frame(height: 54)
        .padding([.horizontal, .vertical])
    }
}


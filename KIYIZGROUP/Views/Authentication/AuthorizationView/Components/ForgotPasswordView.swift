//  ForgotPasswordView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct ForgotPasswordView: View {
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                //
            } label: {
                textComponent.createText(text: "Забыл пароль?", fontSize: 16, fontWeight: .regular, color: Color.colorLightBrown)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

#Preview {
    ForgotPasswordView()
}

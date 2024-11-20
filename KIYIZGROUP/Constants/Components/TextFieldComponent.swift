//  TextFieldComponent.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct TextFieldComponent {
    func createTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, cornerRadius: CGFloat = 24, borderColor: Color = Color.gray.opacity(0.5), padding: CGFloat = 16) -> some View {
        TextField(placeholder, text: text)
            .padding(padding)
            .keyboardType(keyboardType)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

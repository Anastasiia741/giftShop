//  TextFieldComponent.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct TextFieldComponent {
    func createCustomTextField(placeholder: String, text: Binding<String>, color: Color, borderColor: Color) -> some View {
            TextField(placeholder, text: text)
            .font(.custom("Inter", size: 16))
            .padding(12)
            .fontWeight(.regular)
            .foregroundColor(color)
            .frame(height: 50)
            .roundedBorder(borderColor: borderColor)
    }

    func createSecureField(placeholder: String, text: Binding<String>, isPasswordVisible: Binding<Bool>, color: Color, borderColor: Color, frameWidth: CGFloat? = nil) -> some View {
        HStack {
            if isPasswordVisible.wrappedValue {
                TextField(placeholder, text: text)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(color)
                    .padding(12)
                    .frame(height: 50)

            } else {
                SecureField(placeholder, text: text)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(color)
                    .padding(12)
                    .frame(height: 50)
            }
            Button(action: {
                isPasswordVisible.wrappedValue.toggle()
            }) {
                Image(isPasswordVisible.wrappedValue ? "eye.slash" : "eye" )
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(color)
            }
            .padding(.trailing, 12)
        }
        .roundedBorder(borderColor: borderColor)
        .frame(height: 50)
    }
    
    func createTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, cornerRadius: CGFloat = 24, borderColor: Color = Color.gray.opacity(0.5), padding: CGFloat = 16) -> some View {
        TextField(placeholder, text: text)
            .padding(padding)
            .keyboardType(keyboardType)
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(borderColor, lineWidth: 1)
//            )
            .roundedBorder(cornerRadius: cornerRadius, borderColor: borderColor, lineWidth: 1)
    }
    
    func createPromoTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, cornerRadius: CGFloat = 24, borderColor: Color = Color.gray.opacity(0.5), padding: CGFloat = 16,onSubmit: @escaping () -> Void = {}) -> some View {
        TextField(placeholder, text: text)
            .font(.custom("Inter", size: 16))
            .padding(padding)
            .keyboardType(keyboardType)
            .onSubmit(onSubmit)
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(borderColor, lineWidth: 1)
//            )
            .roundedBorder(cornerRadius: cornerRadius, borderColor: borderColor, lineWidth: 1) // Используем расширение

    }
}


struct UnifiedRoundedRectangle: View {
    var isError: Bool = false
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(isError ? Color.red : .gray, lineWidth: 1)
    }
}



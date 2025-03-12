//  TextFieldComponent.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

//MARK: - Auth, Cart
struct TextFieldComponent {
    func createCustomTextField(placeholder: String, text: Binding<String>, borderColor: Color) -> some View {
        TextField(placeholder, text: text)
            .font(.custom("Inter", size: 16))
            .padding(12)
            .fontWeight(.regular)
            .foregroundColor(.primary)
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
            .roundedBorder(cornerRadius: cornerRadius, borderColor: borderColor, lineWidth: 1)
    }
    
    func createPromoTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, cornerRadius: CGFloat = 24, borderColor: Color = Color.gray.opacity(0.5), padding: CGFloat = 16,onSubmit: @escaping () -> Void = {}) -> some View {
        TextField(placeholder, text: text)
            .font(.custom("Inter", size: 16))
            .padding(padding)
            .keyboardType(keyboardType)
            .onSubmit(onSubmit)
            .roundedBorder(cornerRadius: cornerRadius, borderColor: borderColor, lineWidth: 1)
    }
}

//MARK: - AddressInputView, TextFieldComponent
struct RoundedField: View {
    let placeholder: String
    let borderColor: Color
    @Binding var text: String
    
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(borderColor, lineWidth: 1.3)
            )
            .frame(height: 50)
    }
}

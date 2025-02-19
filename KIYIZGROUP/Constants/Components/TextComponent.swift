//  TextComponent.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

final class Extentions: ObservableObject {
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct TextComponent {
    func createText(text: String, fontSize: CGFloat, fontWeight: Font.Weight, style: Font.TextStyle? = nil, color: Color) -> some View {
        Text(text)
            .font(
                style != nil
                ? Font.system(style!)
                : Font.custom("Inter", size: fontSize)
            )
            .fontWeight(fontWeight)
            .foregroundColor(color)
    }
}

struct CustomTextField {
    func createTextField(placeholder: String, text: Binding<String>, fontSize: CGFloat = 16, fontWeight: Font.Weight = .regular, color: Color, borderColor: Color, padding: CGFloat = 12, frameWidth: CGFloat? = nil, frameHeight: CGFloat = 50) -> some View {
            TextField(placeholder, text: text)
            .font(.custom("Inter", size: fontSize))
            .fontWeight(fontWeight)
            .foregroundColor(color)
            .padding(padding)
            .frame(maxWidth: frameWidth, minHeight: frameHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(borderColor, lineWidth: 1.3)
            )
            .frame(height: 50)
    }
}


struct CustomSecureField {
    func createSecureField(placeholder: String, text: Binding<String>, isPasswordVisible: Binding<Bool>, fontSize: CGFloat = 16, fontWeight: Font.Weight = .regular, color: Color, borderColor: Color, padding: CGFloat = 12, frameWidth: CGFloat? = nil, frameHeight: CGFloat = 50) -> some View {
        HStack {
            if isPasswordVisible.wrappedValue {
                TextField(placeholder, text: text)
                    .font(.custom("Inter", size: fontSize))
                    .fontWeight(fontWeight)
                    .foregroundColor(color)
                    .padding(padding)
            } else {
                SecureField(placeholder, text: text)
                    .font(.custom("Inter", size: fontSize))
                    .fontWeight(fontWeight)
                    .foregroundColor(color)
                    .padding(padding)
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
        .frame(maxWidth: frameWidth, minHeight: frameHeight) 
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(borderColor, lineWidth: 1.3)
        )
        .frame(height: 50)
    }
}

//  AddressPhoneSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressPhoneSection: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textComponent.createText(text: "Адрес и номер телефона", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
            HStack {
                textComponent.createText(text: "Добавить адрес", fontSize: 16, fontWeight: .medium, color: colorScheme == .dark ? .white : .black)
                    .foregroundColor(.gray)
                Spacer()
                NavigationLink(destination: AddressInputView()) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.colorDarkBrown)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.5)))
            textFieldComponent.createTextField(placeholder: "+996", text: $phoneNumber, keyboardType: .phonePad)
        }
    }
}

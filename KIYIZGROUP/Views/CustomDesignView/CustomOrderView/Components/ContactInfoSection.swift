//  ContactInfoSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct ContactInfoSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    private let customTextField = CustomTextField()
    
    
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "Контактные данные", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
            
            textComponent.createText(text: "Оставьте свой номер телефона и наш оператор свяжется с вами в ближайшее время для уточнения деталей", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            
            customTextField.createTextField(placeholder: "+996*", text: $phoneNumber, color: colorScheme == .dark ? .white : .black, borderColor: .colorDarkBrown)
                .keyboardType(.numberPad)
                .padding()
        }
    }
}


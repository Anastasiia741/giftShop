//  ContactInfoSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct ContactInfoSection: View {
    private let textComponent = TextComponent()
    private let customTextField = TextFieldComponent()
    
    
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "Контактные данные", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
            
            textComponent.createText(text: "Оставьте свой номер телефона и наш оператор свяжется с вами в ближайшее время для уточнения деталей", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            
            customTextField.createCustomTextField(placeholder: "+996*", text: $phoneNumber, borderColor: .colorDarkBrown)
                .keyboardType(.numberPad)
                .padding()
        }
    }
}


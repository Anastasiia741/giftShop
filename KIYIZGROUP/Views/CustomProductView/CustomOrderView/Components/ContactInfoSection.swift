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
            textComponent.createText(text: "contact_details".localized, fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
            
            textComponent.createText(text: "leave_your_phone".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            
            customTextField.createCustomTextField(placeholder: "+996*", text: $phoneNumber, borderColor: .colorDarkBrown)
                .keyboardType(.numberPad)
                .padding()
        }
    }
}


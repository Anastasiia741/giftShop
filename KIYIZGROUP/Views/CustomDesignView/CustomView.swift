//  CustomView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CustomView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CustomBackButton()
                Spacer()
            }
            .padding([.leading, .top], 16)
            Spacer()
            ProductTypeSection()
                .padding(.vertical)
                .padding(.horizontal, 20)
            DesignSelectionSection()
                .padding(.vertical)
                .padding(.horizontal, 20)

            AdditionalInfoSection()
                .padding(.vertical)
                .padding(.horizontal, 20)
            GreenButton(text: "Продолжить") {
                
            }
            .padding(.horizontal)
            
        }
        .navigationTitle("Индивидуальный заказ")
    }
    
}

#Preview {
    CustomView()
}




struct GreenButton: View {
    private let textComponent = TextComponent()

    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            textComponent.createText(text: text, fontSize: 16, fontWeight: .regular, color: .white)
                .frame(maxWidth: .infinity, maxHeight: 54)
                .background(Color.colorGreen)
                .cornerRadius(40)
        }
        .padding(.top, 16)
    }
}

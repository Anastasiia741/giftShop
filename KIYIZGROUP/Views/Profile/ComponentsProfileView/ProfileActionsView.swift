//  ProfileActionsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileActionsView: View {
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                print("Доставки нажато")
            }) {
                ProfileActionRow(title: "Доставки", subtitle: "2 товара на сумму 4700 сом", textComponent: textComponent)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            Button(action: {
                print("Индивидуальные заказы нажато")
            }) {
                ProfileActionRow(title: "Индивидуальные заказы", subtitle: "2 товара на сумму 4700 сом",textComponent: textComponent)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            Button(action: {
                print("Способ оплаты нажато")
            }) {
                ProfileActionRow(title: "Способ оплаты", subtitle: "2 товара на сумму 4700 сом",textComponent: textComponent)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            Button(action: {
                print("Адрес доставки нажато")
            }) {
                ProfileActionRow(title: "Адрес доставки", subtitle: "2 товара на сумму 4700 сом", textComponent: textComponent)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.colorGreen)
        )
        .padding()
    }
}


struct ProfileActionRow: View {
    let title: String
    let subtitle: String
    let textComponent: TextComponent
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                textComponent.createText(text: title, fontSize: 16, fontWeight: .bold,color: .white)
                textComponent.createText(text: subtitle, fontSize: 14, fontWeight: .regular, color: .white.opacity(0.8))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
    }
}

#Preview {
    ProfileActionsView()
}

//  PaymentMethodSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct PaymentMethodSection: View {
    private let textComponent = TextComponent()
    let payments = ["Оплата курьеру"]
    
    @State private var selectedPayment: String = "Оплата курьеру"
    @State private var showDropdown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textComponent.createText(
                text: "Способ оплаты",
                fontSize: 21,
                fontWeight: .bold,
                style: .headline,
                lightColor: .black,
                darkColor: .white
            )
            
            paymentSelectionView
            
            dropdownButton
            
            if showDropdown {
                paymentOptionsView
            }
        }
    }
}

private extension PaymentMethodSection {
    var paymentSelectionView: some View {
        HStack {
            textComponent.createText(text: selectedPayment, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            Spacer()
            FlashingCircleButton()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    var dropdownButton: some View {
        Button(action: {
            withAnimation {
                showDropdown.toggle()
            }
        }) {
            HStack {
                textComponent.createText(text: "Все способы оплаты", fontSize: 16, fontWeight: .regular, lightColor: .gray, darkColor: .gray)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(showDropdown ? 180 : 0))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(UnifiedRoundedRectangle())
        }
    }
    
    var paymentOptionsView: some View {
        VStack(spacing: 0) {
            ForEach(payments, id: \.self) { method in
                Button(action: {
                    selectedPayment = method
                    withAnimation {
                        showDropdown = false
                    }
                }) {
                    HStack {
                        textComponent.createText(text: method, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                        Spacer()
                    }
                    .padding()
                }
                if method != payments.last {
                    Divider()
                        .padding(.horizontal)
                }
            }
        }
        .padding(8)
        .background(UnifiedRoundedRectangle())
    }
}









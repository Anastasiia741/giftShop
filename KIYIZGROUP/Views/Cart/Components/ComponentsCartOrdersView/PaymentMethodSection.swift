//  PaymentMethodSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct PaymentMethodSection: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    let payments = ["Оплата курьеру"]
    @State private var selectedPayment: String = "Оплата курьеру"
    @State private var showDropdown: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textComponent.createText(text: "Способ оплаты", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
            HStack {
                textComponent.createText(text: "\(selectedPayment)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                Spacer()
                FlashingCircleButton()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).stroke(.gray, lineWidth: 1))
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }) {
                HStack {
                    textComponent.createText(text: "Все способы оплаты", fontSize: 16, fontWeight: .regular, color: .gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showDropdown ? 180 : 0))
                        .foregroundColor(.gray)
                }
                .padding()
//                .background(RoundedRectangle(cornerRadius: 24).stroke(.gray, lineWidth: 1))
                .background(UnifiedRoundedRectangle())

            }
            
            
            if showDropdown {
                VStack(spacing: 0) {
                    ForEach(payments, id: \.self) { method in
                        Button(action: {
                            selectedPayment = method
                            withAnimation {
                                showDropdown = false
                            }
                        }) {
                            HStack {
                                Text(method)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                        }
                        .background(Color.white)
                        
                        if method != payments.last {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(8)
//                .background(RoundedRectangle(cornerRadius: 24).stroke(.gray, lineWidth: 1))
                .background(UnifiedRoundedRectangle())

            }
        }
    }
}


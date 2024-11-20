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
            .background(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.5)))
            Button(action: {
                withAnimation {
                    showDropdown.toggle()
                }
            }) {
                HStack {
                    Text("Все способы оплаты")
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showDropdown ? 180 : 0))
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.5)))
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
                .background(
                    RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }
}

struct FlashingCircleButton: View {
    @State private var isFlashing: Bool = false
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(Color.colorDarkBrown, lineWidth: 2)
                .scaleEffect(isFlashing ? 1.2 : 1.0)
                .opacity(isFlashing ? 0.5 : 1.0)
            
            Circle()
                .fill(Color.colorDarkBrown)
                .padding(4)
        }
        .frame(width: 22, height: 22)
        .onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
                isFlashing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFlashing = false
            }
        }
    }
}

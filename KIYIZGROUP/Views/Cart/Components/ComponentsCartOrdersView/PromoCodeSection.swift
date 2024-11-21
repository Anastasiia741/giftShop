//  PromoCodeSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 21/11/24.

import SwiftUI


struct PromoCodeSection: View {
    @ObservedObject var cartVM: CartVM
    private let textFieldComponent = TextFieldComponent()
    @State private var promoCode = ""
    @State private var placeholderText = "Ввести промокод"
    @State private var showPromoCodeView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textFieldComponent.createPromoTextField(placeholder: placeholderText, text: $promoCode) {
                applyPromoCode()
            }
        }
        .sheet(isPresented: $showPromoCodeView) {
            PromoCodeView(promo: $cartVM.promoResultText, isPromoSheetVisible: $showPromoCodeView)
                .presentationDetents([.height(200)])
        }
    }
    
    private func applyPromoCode() {
        cartVM.promoCode = promoCode
        cartVM.applyPromoCode()
        if promoCode.lowercased() == "promo 10" ||
            promoCode.lowercased() == "promo 20" ||
            promoCode.lowercased() == "promo 30" {
            placeholderText = "Скидка применена"
        } else {
            placeholderText = "Такого кода не существует"
        }
        promoCode = ""
        withAnimation {
            showPromoCodeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showPromoCodeView = false
            }
        }
    }
}



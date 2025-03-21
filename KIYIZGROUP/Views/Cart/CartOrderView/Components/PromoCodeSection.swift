//  PromoCodeSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 21/11/24.

import SwiftUI

struct PromoCodeSection: View {
    @ObservedObject var cartVM: CartVM
    private let textFieldComponent = TextFieldComponent()
    @State private var placeholderText = "enter_promo_code".localized
    @State private var promoCode = ""
    @State private var showPromoCodeView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textFieldComponent.createPromoTextField(placeholder: placeholderText, text: $cartVM.promoCode) { applyPromoCode() }
        }
        .sheet(isPresented: $showPromoCodeView) {
            PromoCodeView(promo: $cartVM.promoResultText, isPromoSheetVisible: $showPromoCodeView)
                .presentationDetents([.height(200)])
        }
        .background(UnifiedRoundedRectangle())
        
    }
}

extension PromoCodeSection {
    private func applyPromoCode() {
        let isPromoApplied = cartVM.applyPromoCode()

        placeholderText = isPromoApplied ? "discount_applied".localized : "there_is_no_such_code".localized
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


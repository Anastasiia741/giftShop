//  PromoCodeView.swift
//  GiftShop
//  Created by Анастасия Набатова on 6/5/24.

import SwiftUI

struct PromoCodeView: View {
    private let textComponent = TextComponent()
    @StateObject private var viewModel = CartVM()
    @Binding var promo: String
    @Binding var isPromoSheetVisible: Bool
    
    var body: some View {
        ZStack {
            Images.Cart.vector
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 20)
                .offset(y: -80)
            VStack {
                Spacer()
                textComponent.createText(text: promo.isEmpty ? "invalid_promo_code".localized : "\(promo)", fontSize: 22, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                    .padding(.vertical)
                    .padding(.horizontal)
            }
            .offset(y: -40)
        }
        .frame(height: 200)
    }
}


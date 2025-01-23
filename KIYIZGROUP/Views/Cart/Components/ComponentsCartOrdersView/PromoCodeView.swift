//  PromoCodeView.swift
//  GiftShop
//  Created by Анастасия Набатова on 6/5/24.

import SwiftUI

struct PromoCodeView: View {
    @Environment(\.colorScheme) var colorScheme
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
                textComponent.createText(text: promo.isEmpty ? "Неверный промокод" : "\(promo)", fontSize: 22, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                    .padding(.vertical)
                    .padding(.horizontal)
            }
            .offset(y: -40)
        }
        .frame(height: 200)
    }
}

struct PromoCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PromoCodeView(promo: .constant(""), isPromoSheetVisible: .constant(false))
    }
}

//  EmptyCartView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 23/1/25.

import SwiftUI

struct EmptyCartView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack {
            Images.Cart.emptyCart
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 130)
                .frame(maxWidth: .infinity)
                .background(Color.clear)
            VStack {
                textComponent.createText(text: Localization.emptyСart, fontSize: 21, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
                .padding(.vertical)
                textComponent.createText(text: Localization.addItemsToCart, fontSize: 16, fontWeight: .regular, color: .gray)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

//  HeaderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let orderProducts: [Product]
    
    var body: some View {
        VStack {
            HStack {
                textComponent.createText(text: "Товары", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                Spacer()
                Button(action: {
                    // Handle edit action
                }) {
                    textComponent.createText(text: "Изменить", fontSize: 16, fontWeight: .medium, color: .colorLightBrown)
                        .font(.body)
                        .foregroundColor(.brown)
                }
            }
            .padding(.vertical)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(orderProducts) { product in
                        CartOrdersCell(position: product)
                    }
                }
            }
        }
    }
}


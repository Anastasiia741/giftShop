//  HeaderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct HeaderView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CartVM()
    private let textComponent = TextComponent()
    let orderProducts: [Product]
    let showEditButton: Bool
    
    var body: some View {
        VStack {
            HStack {
                textComponent.createText(text: "Товары", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                Spacer()
                if showEditButton {
                    Button(action: {
                        dismiss()
                    }) {
                        textComponent.createText(text: "Изменить", fontSize: 16, fontWeight: .medium, lightColor: .colorLightBrown, darkColor: .colorLightBrown)
                            .font(.body)
                            .foregroundColor(.brown)
                    }
                }
            }
            .padding(.vertical, 6)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(orderProducts) { product in
                            CartOrdersCell(position: product)
                                .padding(.vertical)
                    }
                }
            }
        }
    }
}


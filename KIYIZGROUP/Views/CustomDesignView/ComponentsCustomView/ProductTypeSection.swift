//  ProductTypeSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI

struct ProductTypeSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textComponent.createText(text: "Тип товара", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.bottom, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(ProductType.allCases, id: \.self) { type in
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                                Image(type.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(8)
                            }
                            .frame(width: 97, height: 111)
                            textComponent.createText(text: type.title, fontSize: 12, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        }
                        .cornerRadius(16)

                    }
                }
            }
        }
    }
}

enum ProductType: String, CaseIterable {
    case wallet = "Кошелек"
    case backpack = "Рюкзак"
    case bag = "Сумка"

    var title: String { rawValue }
    var imageName: String {
        switch self {
        case .wallet: return "bag"
        case .backpack: return "bag"
        case .bag: return "bag"
        }
    }
}

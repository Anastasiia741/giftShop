//  PopularSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

struct PopularSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 2.2))]
    let products: [Product]
    @State var currentTab = 0
    
    var body: some View {
        VStack(alignment: .leading ) {
            textComponent.createText(text: Localization.popular, fontSize: 28, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                .padding(.leading, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: layoutForPopular, spacing: 6) {
                    ForEach(products) { item in
                        NavigationLink {
                            let viewModel = ProductDetailVM(product: item)
                            ProductDetailView(viewModel: viewModel, currentUserId: "", currentTab: $currentTab)
                        } label: {
                            PopularProductCell(product: item)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
            }
            .padding(.leading, 20)
        }
    }
}

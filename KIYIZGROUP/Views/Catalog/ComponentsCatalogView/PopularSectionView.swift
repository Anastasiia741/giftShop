//  PopularSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

struct PopularSectionView: View {
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 2.2))]
    private let textComponent = TextComponent()
    let products: [Product]
    @State var currentTab = 0
    
    var body: some View {
        VStack(alignment: .leading ) {
            textComponent.createText(text: Localization.popular, fontSize: 28, fontWeight: .heavy, lightColor: .black, darkColor: .white)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: layoutForPopular, spacing: 6) {
                    ForEach(products) { item in
                        NavigationLink {
                            let viewModel = ProductDetailVM(product: item)
                            ProductDetailView(viewModel: viewModel, currentUserId: "", currentTab: $currentTab)
                        } label: {
                            PopularProductCell(product: item)
                                .foregroundColor(ColorManager.adaptiveColor(light: .black, dark: .white))
                        }
                    }
                }
            }
        }
    }
}

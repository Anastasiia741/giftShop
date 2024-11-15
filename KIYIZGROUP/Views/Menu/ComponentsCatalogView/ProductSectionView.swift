//  ProductSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct ProductSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    private let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    let filteredProducts: [Product]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: layoutForProducts) {
                ForEach(filteredProducts) { item in
                    NavigationLink {
                        let viewModel = ProductDetailVM(product: item)
                        ProductDetailView(viewModel: viewModel, currentUserId: "")
                    } label: {
                        ProductCell(product: item)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
        }
    }
}

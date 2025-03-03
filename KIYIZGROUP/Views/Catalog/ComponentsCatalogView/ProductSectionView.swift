//  ProductSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct ProductSectionView: View {
    private let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @StateObject var viewModel: CatalogVM
    let filteredProducts: [Product]
    @Binding var currentTab: Int

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: layoutForProducts) {
                ForEach(filteredProducts) { item in
                    NavigationLink {
                        let viewModel = ProductDetailVM(product: item)
                        ProductDetailView(viewModel: viewModel, currentUserId: "", currentTab: $currentTab)
                    } label: {
                        ProductCell(product: item)
                    }
                }
            }
        }
    }
}



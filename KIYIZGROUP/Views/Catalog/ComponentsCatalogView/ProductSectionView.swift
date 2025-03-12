//  ProductSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct ProductSectionView: View {
    private let layoutForProducts = [GridItem(.adaptive(minimum: UIScreen.main.bounds.width / 2.4))]
    @StateObject var viewModel: CatalogVM
    let filteredProducts: [Product]
//    @Binding var navigationPath: NavigationPath
    @Binding var currentTab: Int
    @Binding var selectedProduct: Product?


    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: layoutForProducts, spacing: 12) {
                ForEach(filteredProducts) { item in
                    Button {
                        selectedProduct = item
                    } label: {
                        ProductCell(product: item)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 16)
                    }
                }
            }
            .padding(.horizontal, 6)
        }
    }
}




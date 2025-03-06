//  ProductEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct ProductsEditView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: CatalogVM
    private let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            DetailButton(
                                text: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = category
                                viewModel.filterProducts(by: category)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: layoutForProducts, spacing: 8) {
                    ForEach(viewModel.filteredProducts) { item in
                        NavigationLink {
                            let viewModel = ProductEditVM(selectedProduct: item)
                            ProductEditView(viewModel: viewModel)
                        } label: {
                            ProductCell(product: item)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .onAppear {
                Task {
                    await viewModel.fetchProducts()
                }
            }
            .navigationTitle("Товары")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

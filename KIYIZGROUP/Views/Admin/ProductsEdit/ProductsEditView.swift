//  ProductEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct ProductsEditView: View {
    private let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @StateObject var viewModel: CatalogVM
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                categoryScrollView
                productsGridView
            }
            .navigationTitle("Товары")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await fetchAndFilterProducts()
            }
        }
    }
}

extension ProductsEditView {
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    DetailButton(text: category, isSelected: viewModel.selectedCategory == category) {
                        viewModel.selectedCategory = category
                        viewModel.filterProducts(by: category)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private var productsGridView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: layoutForProducts, spacing: 8) {
                ForEach(viewModel.filteredProducts) { item in
                    productNavigationLink(for: item)
                }
            }
            .padding(.horizontal, 8)
        }
    }

    @ViewBuilder
    private func productNavigationLink(for product: Product) -> some View {
        NavigationLink(destination: ProductEditView(viewModel: ProductEditVM(selectedProduct: product))) {
            ProductCell(product: product)
        }
    }

    @MainActor
    private func fetchAndFilterProducts() async {
        await viewModel.fetchProducts()
        viewModel.filterProducts(by: viewModel.selectedCategory)
    }
}

//  CatalogView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogVM()
    @State private var isLoading = false
    @Binding var currentTab: Int
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    Spacer()
                    LoadingView()
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        PopularSectionView(products: viewModel.popularProducts)
                            .padding(.vertical)
                            .padding(.horizontal, 20)
                        CustomDesignSectionView()
                            .padding(.horizontal, 20)
                        CategorySectionView(selectedCategory: $viewModel.selectedCategory, onCategorySelected: { category in
                            viewModel.filterProducts(by: category)
                        }, categories: viewModel.categories)
                        
                        ProductSectionView(filteredProducts: viewModel.filteredProducts, currentTab: $currentTab)
                            .padding(.horizontal, 30)
                    }
                }
            }
            .task {
                isLoading = true
                await self.viewModel.fetchAllProducts()
                isLoading = false
            }
        }
    }
}









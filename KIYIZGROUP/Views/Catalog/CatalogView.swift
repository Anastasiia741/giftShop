//  CatalogView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogVM()
    @State private var customOrder = CustomOrder(userID: "", phone: "", product: nil, style: nil, attachedImageURL: "", additionalInfo: "", date: Date())
    @Binding var navigationPath: NavigationPath
    @Binding var currentTab: Int
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                        
                        CustomDesignSectionView(customOrder: customOrder, navigationPath: $navigationPath, currentTab: $currentTab)
                            .padding(.horizontal, 20)
                        
                        CategorySectionView(selectedCategory: $viewModel.selectedCategory, onCategorySelected: { category in
                            viewModel.filterProducts(by: category)
                        }, categories: viewModel.categories, showText: true)
                        
                        ProductSectionView(viewModel: viewModel, filteredProducts: viewModel.filteredProducts, navigationPath: $navigationPath, currentTab: $currentTab)
                            .padding(.horizontal, 30)
                            .environmentObject(viewModel)
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                let productVM = ProductDetailVM(product: product)
                ProductDetailView(viewModel: productVM, currentUserId: "", currentTab: $currentTab)
            }
            .navigationDestination(for: CustomOrder.self) { customOrder in
                CustomView(customOrder: customOrder, currentTab: $currentTab)
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await self.viewModel.fetchProducts()
                isLoading = false
            }
        }
    }
}










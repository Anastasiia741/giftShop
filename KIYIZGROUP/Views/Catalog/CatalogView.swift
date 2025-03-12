//  CatalogView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogVM()
    @State private var customOrder = CustomOrder(userID: "", phone: "", product: nil, style: nil, attachedImageURL: "", additionalInfo: "", date: Date())
    @Binding var currentTab: Int
    @State private var showCustomView = false
    @State private var selectedProduct: Product?
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    Spacer()
                    LoadingView()
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        PopularSectionView(products: viewModel.popularProducts)
                            .padding(.vertical)
                            .padding(.horizontal)
                        
                        CustomDesignSectionView(customOrder: customOrder, currentTab: $currentTab, showCustomView: $showCustomView)
                        
                        CategorySectionView(selectedCategory: $viewModel.selectedCategory, onCategorySelected: { category in
                            viewModel.filterProducts(by: category)
                        }, categories: viewModel.categories, showText: true)
                        
                        ProductSectionView(viewModel: viewModel, filteredProducts: viewModel.filteredProducts, currentTab: $currentTab, selectedProduct: $selectedProduct)
                            .environmentObject(viewModel)
                    }
                }
            }
            .navigationDestination(isPresented: $showCustomView) {
                CustomView(customOrder: customOrder, currentTab: $currentTab)
            }
            .navigationDestination(item: $selectedProduct) { product in
                ProductDetailView(viewModel: ProductDetailVM(product: product), currentUserId: "", currentTab: $currentTab)
            }

            .navigationBarTitleDisplayMode(.inline)
            .task {
                await self.viewModel.fetchProducts()
                viewModel.filterProducts(by: viewModel.selectedCategory) 
                isLoading = false
            }
        }
    }
}










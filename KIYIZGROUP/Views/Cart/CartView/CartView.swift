//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var catalogVM = CatalogVM()
    @StateObject private var viewModel = CartVM()
    private let buttonComponents = ButtonComponents()
    let currentUserId: String
    @Binding var currentTab: Int
    @State private var showOrderView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.orderProducts.isEmpty {
                    VStack {
                        EmptyCartView()
                            .frame(maxHeight: .infinity, alignment: .top)
                        PopularSectionView(products: catalogVM.popularProducts)
                            .padding(.vertical)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                } else {
                    CartProductsList(viewModel: viewModel)
                    
                    buttonComponents.createOrderButton(amount: "\(viewModel.productCountMessage)", action: {
                        showOrderView.toggle()
                    })
                }
            }
            .padding([.vertical, .horizontal])
            .navigationTitle("Koрзина")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showOrderView) {
                CartOrderView(currentTab: $currentTab)
            }
            .onAppear {
                viewModel.fetchOrder()
                Task {
                    await catalogVM.fetchProducts()
                }
            }
        }
    }
}








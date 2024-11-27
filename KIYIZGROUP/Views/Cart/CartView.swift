//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = CartVM()
    @StateObject private var catalogVM = CatalogVM()
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 1.8))]
    private let buttonComponents = ButtonComponents()
    private let textComponent = TextComponent()
    let currentUserId: String
    @Binding var currentTab: Int
    @State private var promo: String = ""
    @State private var isPresented = false
    @State private var navigateToCatalog = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.orderProducts.isEmpty {
                    VStack {
                        if viewModel.orderProducts.isEmpty {
                            Images.Cart.emptyCart
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 130)
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                            VStack {
                                textComponent.createText(text: Localization.emptyСart, fontSize: 21, fontWeight: .bold, color: colorScheme == .dark ? .white : .black )
                                    .padding(.vertical)
                                textComponent.createText(text: Localization.addItemsToCart, fontSize: 16, fontWeight: .regular, color: .gray)
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.orderProducts) { product in
                                CartCell(viewModel: viewModel, position: product)
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                    }
                    buttonComponents.createOrderButton(amount: "\(viewModel.productCountMessage)") {
                        navigateToCatalog = true
                    }
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle(Localization.cart)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToCatalog) {
                CartOrdersView()
            }
        }
        .onAppear {
            viewModel.fetchOrder()
            Task {
                await catalogVM.fetchAllProducts()
            }
        }
    }
}





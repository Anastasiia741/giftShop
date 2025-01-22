//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var catalogVM = CatalogVM()
    @StateObject private var viewModel = CartVM()
    private let textComponent = TextComponent()
    private let buttonComponents = ButtonComponents()
    let currentUserId: String
    @Binding var currentTab: Int
    @State private var promo = ""
    @State private var isPresented = false
    @State private var navigateToCatalog = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.orderProducts.isEmpty {
                    EmptyCartView()
                } else {
                    CartProductsList(viewModel: viewModel)
                    
                    OrderButton(amount: "\(viewModel.productCountMessage)", currentUserId: currentUserId, currentTab: $currentTab, navigateToCatalog: $navigateToCatalog)
                }
            }
            .padding([.vertical, .horizontal])
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




struct EmptyCartView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack {
            Images.Cart.emptyCart
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 130)
                .frame(maxWidth: .infinity)
                .background(Color.clear)
            VStack {
                textComponent.createText(
                    text: Localization.emptyСart,
                    fontSize: 21,
                    fontWeight: .bold,
                    color: colorScheme == .dark ? .white : .black
                )
                .padding(.vertical)
                textComponent.createText(
                    text: Localization.addItemsToCart,
                    fontSize: 16,
                    fontWeight: .regular,
                    color: .gray
                )
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}


struct CartProductsList: View {
    @ObservedObject var viewModel: CartVM
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.orderProducts) { product in
                    CartCell(viewModel: viewModel, position: product)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
        }
    }
}

struct OrderButton: View {
    let amount: String
    let currentUserId: String
    @Binding var currentTab: Int
    @Binding var navigateToCatalog: Bool
    private let buttonComponents = ButtonComponents()
    
    var body: some View {
        buttonComponents.createOrderButton(amount: amount) {
            if currentUserId.isEmpty {
                currentTab = TabType.profile.rawValue
            } else {
                navigateToCatalog = true
            }
        }
        .padding(.bottom, 12)
    }
}

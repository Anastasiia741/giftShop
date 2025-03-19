//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    @StateObject private var catalogVM = CatalogVM()
    @StateObject var profileVM = ProfileVM()
    @StateObject private var viewModel = CartVM()
    private let buttonComponents = ButtonComponents()
    let currentUserId: String
    @Binding var currentTab: Int
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
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
                        navigationPath.append(CartNavigation.cartOrderView)
                    })
                }
            }
            .padding([.vertical, .horizontal])
            .navigationTitle("cart".localized)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: CartNavigation.self) { destination in
                switch destination {
                case .cartOrderView:
                    CartOrderView(profileVM: profileVM, navigationPath: $navigationPath, currentTab: $currentTab)
                case .orderDetailsView(let order):
                    OrderDetailsView(currentTab: $currentTab, orderProducts: viewModel.orderProducts, order: order)
                case .addressInputView:
                    AddressInputView(profileVM: ProfileVM(), cartVM: viewModel, currentTab: $currentTab)
                }
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








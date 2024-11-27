//  CartOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI

struct CartOrdersView: View {
    private let buttonComponents = ButtonComponents()
    @StateObject private var viewModel = CartVM()
    @State private var promo: String = ""
    @State private var placedOrder: Order?
    @State private var orderPlaced = false
    @State private var showOrderDetails = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            if showOrderDetails, let order = placedOrder {
                OrderDetailsView(orderProducts: viewModel.orderProducts, order: order)
                    .transition(.move(edge: .trailing))
            } else {
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            HeaderView(orderProducts: viewModel.orderProducts,  showEditButton: true)
                            
                            AddressPhoneSection()
                            
                            PaymentMethodSection()
                            
                            PromoCodeSection(cartVM: viewModel)
                            
                            OrderSummaryView(viewModel: viewModel)
                            
                            buttonComponents.createOrdersButton(amount: "\(viewModel.productCountMessage)") {
                                placeOrder()
                            }
                        }
                        .padding()
                        .navigationTitle("Оформление заказа")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .onAppear {
                        viewModel.fetchOrder()
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: CustomBackButton())
                }
            }
            
            if isLoading {
                VStack {
                    LoadingView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                .transition(.opacity)
                .zIndex(2)
            }
            
            if orderPlaced {
                InfoView(isOpenView: $orderPlaced)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .background(Color.black.opacity(0.6).edgesIgnoringSafeArea(.all))
                    .zIndex(1)
                    .onDisappear {
                        showOrderDetails = true
                    }
            }
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: orderPlaced)
    }
    
    private func placeOrder() {
        isLoading = true
        viewModel.orderButtonTapped(with: promo) { order in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.isLoading = false
                self.placedOrder = order
                self.orderPlaced = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.orderPlaced = false
                    self.showOrderDetails = true
                }
            }
        }
    }
}

#Preview {
    CartOrdersView()
}





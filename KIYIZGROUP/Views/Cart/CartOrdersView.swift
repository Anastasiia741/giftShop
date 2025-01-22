//  CartOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI

struct CartOrdersView: View {
    private let buttonComponents = ButtonComponents()
    @StateObject private var profileViewModel = ProfileVM()
    @StateObject private var viewModel = CartVM()
    @State private var placedOrder: Order?
    @State private var promo: String = ""
    @State private var orderPlaced = false
    @State private var showOrderDetails = false
    @State private var isAddressValid = true
    @State private var isPhoneValid = true
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
                            
                            AddressPhoneSection(viewModel: profileViewModel, isAddressValid: $isAddressValid, isPhoneValid: $isPhoneValid)
                            
                            PaymentMethodSection()
                            
                            PromoCodeSection(cartVM: viewModel)
                            
                            OrderSummaryView(viewModel: viewModel)
   
                            buttonComponents.createOrdersButton(
                                amount: "\(viewModel.productCountMessage)",
                                isDisabled: false
                            ) {
                                if profileViewModel.address.isEmpty || profileViewModel.phone.isEmpty {
                                    isAddressValid = !profileViewModel.address.isEmpty
                                    isPhoneValid = !profileViewModel.phone.isEmpty
                                } else {
                                    placeOrder()
                                }
                            }
                        }
                        .padding()
                        .navigationTitle("Оформление заказа")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .onAppear {
                        viewModel.fetchOrder()
                        Task {
                            await profileViewModel.fetchUserProfile()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: CustomBackButton())
                    .scrollIndicators(.hidden)
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
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
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





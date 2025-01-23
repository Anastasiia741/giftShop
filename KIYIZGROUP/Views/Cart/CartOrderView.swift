//  CartOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI

struct CartOrderView: View {
    private let buttonComponents = ButtonComponents()
    @StateObject private var profileViewModel = ProfileVM()
    @StateObject private var viewModel = CartVM()
    @State private var placedOrder: Order?
    @State private var promo = ""
    @State private var showInfoView = false
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
                            HeaderView(orderProducts: viewModel.orderProducts, showEditButton: true)
                            
                            AddressPhoneSection(viewModel: profileViewModel, isAddressValid: $isAddressValid, isPhoneValid: $isPhoneValid)
                            
                            PaymentMethodSection()
                            
                            PromoCodeSection(cartVM: viewModel)
                            
                            OrderSummaryView(viewModel: viewModel)
                            
                            buttonComponents.createOrdersButton(amount: "\(viewModel.productCountMessage)", isDisabled: false) {
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
                Spacer()
                LoadingView()
                Spacer()
                    .transition(.opacity)
                
            }
            if showInfoView {
                InfoView(isOpenView: $showInfoView)
                    .onDisappear {
                        showOrderDetails = true
                    }
            }
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: showInfoView)
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
    }
}

extension CartOrderView{
    private func placeOrder() {
        isLoading = true
        Task {
            let order = await viewModel.saveOrder(with: viewModel.promoCode)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isLoading = false
                if let order = order {
                    placedOrder = order
                    showInfoView = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        showInfoView = false
                    }
                }
            }
        }
    }
}



//  CartOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI

struct CartOrderView: View {
    @Environment(\.dismiss) private var dismiss
    private let buttonComponents = ButtonComponents()
    @StateObject private var profileViewModel = ProfileVM()
    @StateObject private var viewModel = CartVM()
    @State private var order: Order?
    @State private var promo = ""
    @Binding var navigationPath: NavigationPath
    @Binding var currentTab: Int
    
    @State private var showInfoView = false
    @State private var isAddressValid = true
    @State private var isPhoneValid = true
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HeaderView(orderProducts: viewModel.orderProducts, showEditButton: true)
                        AddressPhoneSection(profileVM: profileViewModel, navigationPath: $navigationPath, isAddressValid: $isAddressValid, isPhoneValid: $isPhoneValid)
                        PaymentMethodSection()
                        PromoCodeSection(cartVM: viewModel)
                        OrderSummaryView(viewModel: viewModel)
                        
                        buttonComponents.createOrdersButton(
                            amount: "\(viewModel.productCountMessage)",
                            isDisabled: !isFormValid()
                        ) {
                            placeOrder()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .scrollIndicators(.hidden)
            }
            
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            }
            
            if showInfoView {
                InfoView(isOpenView: $showInfoView)
                    .onDisappear {
                        if let order = order {
                            navigationPath.append(CartNavigation.orderDetailsView(order))
                        }
                    }
            }
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: showInfoView)
        .navigationTitle("Оформление заказа")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: CustomBackButton())
        .onChange(of: currentTab) { _, _ in
            navigationPath.removeLast()
            dismiss()
        }
        
        .onAppear {
            viewModel.fetchOrder()
            viewModel.fetchGuestData()
            Task {
                await profileViewModel.fetchUserProfile()
            }
        }
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
    }
}

extension CartOrderView {
    private func isFormValid() -> Bool {
        let address = profileViewModel.authService.currentUser != nil ? profileViewModel.address : viewModel.address
        let phone = profileViewModel.authService.currentUser != nil ? profileViewModel.phone : viewModel.phone
        
        return !address.isEmpty && !phone.isEmpty
    }
    
    
    private func placeOrder() {
        isLoading = true
        Task {
            let newOrder = await viewModel.saveOrder(with: viewModel.promoCode, profileVM: profileViewModel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isLoading = false
                if let newOrder = newOrder {
                    order = newOrder
                    showInfoView = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        showInfoView = false
                    }
                }
            }
        }
    }
}


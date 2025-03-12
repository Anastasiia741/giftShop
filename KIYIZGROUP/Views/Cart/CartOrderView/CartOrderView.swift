//  CartOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI

struct CartOrderView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profileVM: ProfileVM
    @StateObject private var viewModel = CartVM()
    private let buttonComponents = ButtonComponents()
    @State private var order: Order?
    @State private var promo = ""
    @Binding var navigationPath: NavigationPath
    @Binding var currentTab: Int
    
    @State private var showInfoView = false
    @State private var isLoading = false
    @State private var isValidation = false
    
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HeaderView(orderProducts: viewModel.orderProducts, showEditButton: true)
                        AddressPhoneSection(profileVM: profileVM, navigationPath: $navigationPath, isValidate: isValidation)
                        PaymentMethodSection()
                        PromoCodeSection(cartVM: viewModel)
                        OrderSummaryView(viewModel: viewModel)
                        
                        buttonComponents.createOrdersButton(amount: "\(viewModel.productCountMessage)", color: isFormValid() ? .white : .gray, backgroundColor: isFormValid() ? .colorGreen : .clear, borderColor: isFormValid() ?  .clear : .gray) {
                            createOrder()
                        }
                        .padding(.vertical)
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
                await profileVM.fetchUserProfile()
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
        let address = profileVM.authService.currentUser != nil ? profileVM.address : viewModel.address
        let phone = profileVM.authService.currentUser != nil ? profileVM.phone : viewModel.phone
        return !address.isEmpty && !phone.isEmpty
    }
    
    private func createOrder() {
        isValidation = true
        if isFormValid() {
            if profileVM.authService.currentUser == nil {
                UserDefaults.standard.set(viewModel.phone, forKey: "guestPhone")
            }
            placeOrder()
        }
    }
    
    private func placeOrder() {
        isLoading = true
        Task {
            let newOrder = await viewModel.saveOrder(with: viewModel.promoCode, profileVM: profileVM)
            
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


//  CartOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI

struct CartOrdersView: View {
    @StateObject private var viewModel = CartVM()
    private let buttonComponents = ButtonComponents()
    @State private var promo: String = ""
    @State private var orderPlaced = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HeaderView(orderProducts: viewModel.orderProducts)
                    
                    AddressPhoneSection()
                    
                    PaymentMethodSection()
                    
                    PromoCodeSection(cartVM: viewModel)
                    
                    OrderSummaryView(viewModel: viewModel)
                    
                    buttonComponents.createOrdersButton(amount: "\(viewModel.productCountMessage)") {
                        viewModel.orderButtonTapped(with: promo)
                        orderPlaced = true
                    }
                }
                .padding()
                .navigationTitle("Оформление заказа")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            viewModel.fetchOrder()
        }
        
        
    }
}

#Preview {
    CartOrdersView()
}




struct PromoCodeSection: View {
    @ObservedObject var cartVM: CartVM
    private let textFieldComponent = TextFieldComponent()
    
    @State private var promoCode: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            textFieldComponent.createTextField(placeholder: "Ввести промокод", text: $promoCode)
            Button(action: {
                cartVM.promoCode = promoCode
                cartVM.applyPromoCode()
                
                alertMessage = cartVM.promoResultText
                showAlert = true
                promoCode = ""
            }) {
                
            }
        }
        .alert(item: $cartVM.alertModel) { model in
            Alert(
                title: Text(model.title ?? ""),
                message: Text(model.message ?? ""),
                dismissButton: .default(Text(model.buttons.first?.title ?? "OK")) {
                    model.buttons.first?.action?()
                }
            )
        }
    }
}



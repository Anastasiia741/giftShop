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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

#Preview {
    CartOrdersView()
}





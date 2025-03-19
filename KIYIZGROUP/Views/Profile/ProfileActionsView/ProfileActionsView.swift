//  ProfileActionsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileActionsView: View {
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    @Binding var currentTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            if let lastOrder = viewModel.orders.max(by: { $0.date < $1.date }) {
                let itemsWord = getItemsWord(for: lastOrder.totalItems)
                NavigationLink(destination: DeliveryView(viewModel: viewModel, currentTab: $currentTab)) {
                    ProfileActionRow(title: "deliveries".localized,
                                     subtitle: "\(lastOrder.totalItems) \(itemsWord) \("for_the_amount".localized) \(lastOrder.cost) \("com".localized)", textComponent: textComponent, showChevron: true)
                }
            } else {
                ProfileActionRow(title: "deliveries".localized, subtitle: "no_deliveries_expected".localized, textComponent: textComponent, showChevron: false)
            }
            CustomDivider()
            
            if let lastCustomOrder = viewModel.customOrders.max(by: { $0.date < $1.date }) {
                NavigationLink(destination: CustomOrdersView(viewModel: viewModel, currentTab: $currentTab)) {
                    ProfileActionRow(title: "individual_orders".localized, subtitle: "\(lastCustomOrder.product?.name ?? "order_missing".localized)", textComponent: textComponent, showChevron: true)
                }
            } else {
                ProfileActionRow(title: "individual_orders".localized, subtitle: "no_orders".localized, textComponent: textComponent, showChevron: false)
            }
            
            CustomDivider()
            
            ProfileActionRow(title: "payment_method".localized, subtitle: "payment_to_courier".localized, textComponent: textComponent, showChevron: false)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.colorGreen)
        )
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchUserProfile()
            }
            viewModel.fetchOrders()
            viewModel.fetchCustomOrder()
        }
    }
}

extension ProfileActionsView {
    func getItemsWord(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "goods".localized
        } else if lastDigit == 1 {
            return "good".localized
        } else if lastDigit >= 2 && lastDigit <= 4 {
            return "goodss".localized
        } else {
            return "goods".localized
        }
    }
}

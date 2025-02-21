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
            if let lastOrder = viewModel.lastOrder {
                NavigationLink(destination: DeliveryView(viewModel: viewModel, currentTab: $currentTab)) {
                    ProfileActionRow(title: "Доставки", subtitle: "\(lastOrder.totalItems) товара на сумму \(lastOrder.cost) сом", textComponent: textComponent, showChevron: true)
                }
            } else {
                ProfileActionRow(title: "Доставки", subtitle: "Доставок не ожидается", textComponent: textComponent, showChevron: false)
            }
            CustomDivider()
            
            if let lastCustomOrder = viewModel.customOrders.max(by: { $0.date < $1.date }) {
                NavigationLink(destination: CustomOrdersView(viewModel: viewModel, currentTab: $currentTab)) {
                    ProfileActionRow(
                        title: "Индивидуальные заказы",
                        subtitle: "\(lastCustomOrder.product?.name ?? "Заказ отсутствует")",
                        textComponent: textComponent,
                        showChevron: true
                    )
                }
            } else {
                ProfileActionRow(
                    title: "Индивидуальные заказы",
                    subtitle: "Заказы отсутствуют",
                    textComponent: textComponent,
                    showChevron: false
                )
            }
            
            CustomDivider()
            
            ProfileActionRow(title: "Способ оплаты", subtitle: "Оплата курьеру",textComponent: textComponent, showChevron: false)
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



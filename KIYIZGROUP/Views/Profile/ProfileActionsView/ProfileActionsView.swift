//  ProfileActionsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileActionsView: View {
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
            if let lastOrder = viewModel.lastOrder {
                NavigationLink(destination: DeliveryView(viewModel: viewModel)) {
                    ProfileActionRow(title: "Доставки", subtitle: "\(lastOrder.totalItems) товара на сумму \(lastOrder.cost) сом", textComponent: textComponent)
                }
            } else {
                ProfileActionRow(title: "Доставки", subtitle: "Доставок не ожидается", textComponent: textComponent)
            }
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            if viewModel.lastIndOrder {
                NavigationLink(destination: CustomOrdersView(viewModel: viewModel)) {
                    ProfileActionRow(title: "Индивидуальные заказы", subtitle: "Название товара",textComponent: textComponent)
                }
            } else {
                ProfileActionRow(title: "Индивидуальные заказы", subtitle: "Заказы отсутствуют",textComponent: textComponent)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            ProfileActionRow(title: "Способ оплаты", subtitle: "Оплата курьеру",textComponent: textComponent)
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
//            NavigationLink(destination: EditProfileView(viewModel: viewModel)) {
//                ProfileActionRow(title: "Адрес доставки", subtitle: viewModel.address.isEmpty ? "Не указан" : viewModel.address, textComponent: textComponent)
//            }
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
            viewModel.fetchOrderHistory()
        }
    }
}




#Preview {
    ProfileActionsView()
}

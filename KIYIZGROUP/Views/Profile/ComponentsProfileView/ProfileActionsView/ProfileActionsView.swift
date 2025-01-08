//  ProfileActionsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileActionsView: View {
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    @State private var count = 1
    
    var body: some View {
        VStack(spacing: 0) {
            if let lastOrder = viewModel.lastOrder, lastOrder.status == OrderStatus.new.rawValue || lastOrder.status == OrderStatus.shipped.rawValue {
                NavigationLink(destination: DeliveryView(viewModel: viewModel)) {
                    ProfileActionRow(
                        title: "Доставки",
                        subtitle: "\(lastOrder.totalItems) товара на сумму \(lastOrder.cost) сом", textComponent: textComponent
                    )
                }
            } else {
                Text("Доставок не ожидается")
                    .foregroundColor(.gray)
                    .padding()
            }
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            NavigationLink(destination: CustomOrdersView()) {
                ProfileActionRow(title: "Индивидуальные заказы", subtitle: "Заказы отсутствуют",textComponent: textComponent)
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            ProfileActionRow(title: "Способ оплаты", subtitle: "Оплата курьеру",textComponent: textComponent)
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            NavigationLink(destination: AddressView()) {
                ProfileActionRow(title: "Адрес доставки", subtitle: "2 товара на сумму 4700 сом", textComponent: textComponent)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.colorGreen)
        )
        .padding()
        .onAppear {
            viewModel.fetchOrderHistory()
        }
    }
}




#Preview {
    ProfileActionsView()
}

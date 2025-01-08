//  DeliveryView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/1/25.

import SwiftUI

struct DeliveryView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ProfileVM
    @StateObject private var statusColors = StatusColors()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack {
            if viewModel.orders.isEmpty {
                textComponent.createText(text: "Заказов пока нет", fontSize: 16, fontWeight: .regular, color: .gray)
                    .padding()
            } else {
                List(viewModel.orders) { order in
                    VStack(alignment: .leading) {
                        textComponent.createText(text: "Дата: \(Extentions().formattedDate(order.date))", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        HStack {
                            textComponent.createText(text: "Статус: ", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                            textComponent.createText(text: "\(order.status)", fontSize: 16, fontWeight: .regular, color: statusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                        }
                        textComponent.createText(text: "Сумма: \(order.cost) сом", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        textComponent.createText(text: "Товары: \(order.totalItems)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}


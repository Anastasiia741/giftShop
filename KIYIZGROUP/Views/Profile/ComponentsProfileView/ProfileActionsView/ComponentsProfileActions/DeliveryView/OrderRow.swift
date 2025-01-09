//  OrderRow.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/1/25.

import SwiftUI

struct OrderRow: View {
    let order: Order
    let colorScheme: ColorScheme
    let statusColors: StatusColors
    let textComponent: TextComponent
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                textComponent.createText(text: "Статус заказа", fontSize: 14, fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: order.status, fontSize: 14, fontWeight: .bold, color: statusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
            }
            .padding(.vertical, 6)
            HStack {
                textComponent.createText(text: "Номер заказа", fontSize: 14,fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: "\(order.id.prefix(6))", fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding(.vertical, 6)
            HStack {
                textComponent.createText(text: "Дата и время заказа", fontSize: 14, fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: Extentions().formattedDate(order.date), fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding(.vertical, 6)
            Divider()
            HStack {
                Spacer()
                textComponent.createText(text: "Сумма: \(order.cost) сом", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding(.vertical, 6)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(colorScheme == .dark ? Color.black : Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(colorScheme == .dark ? Color.gray : Color(UIColor.systemGray4), lineWidth: 1)
        )
        .padding(.vertical, 4)
    }
}


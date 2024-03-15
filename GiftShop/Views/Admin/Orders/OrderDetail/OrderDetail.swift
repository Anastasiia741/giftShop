//  OrderDetail.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI

struct OrderDetail: View {
    
    @ObservedObject var orderDetailVM: OrderDetailVM
    private let order: Order
    
    init(orderDetailVM: OrderDetailVM, order: Order) {
        self.orderDetailVM = orderDetailVM
        self.order = order
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Детали заказа")
                .customTextStyle(TextStyle.avenirRegular, size: 22)
                .fontWeight(.bold)
                .padding(.top)
            VStack(alignment: .leading, spacing: 10) {
                Text("Дата заказа: \(Extentions.shared.formattedDate(order.date))")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("Статус: \(order.status)")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                    .foregroundColor(Extentions.shared.statusColor(for: order.status))
                Text("Промокод: \(order.promocode)")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 10) {
                Text("Товары:")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                    .bold()
                ForEach(order.positions) { position in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Название: \(position.product.name): \(position.count) шт.")
                                .customTextStyle(TextStyle.avenirRegular, size: 16)
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                }
            }
            .padding(.horizontal)
            Text("Сумма: \(order.cost) сом")
                .customTextStyle(TextStyle.avenirRegular, size: 18)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            Text("Имя: ")
                .customTextStyle(TextStyle.avenirRegular, size: 18)
            Text("Email: ")
                .customTextStyle(TextStyle.avenirRegular, size: 18)
            Text("Адрес доставки: ")
                .customTextStyle(TextStyle.avenirRegular, size: 18)
            Text("Номер телефона: ")
                .customTextStyle(TextStyle.avenirRegular, size: 18)
            Spacer()
        }
        Button(action: {
        }) {
            Text("\(order.status)")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .frame(maxWidth: 130, minHeight: 50)
                .foregroundColor(.white)
                .background(Color(.green))
                .cornerRadius(20)
                .shadow(color: Color(.green).opacity(0.5), radius: 5, x: 0, y: 5)
        }
        .padding(.bottom, 22)
    }
}



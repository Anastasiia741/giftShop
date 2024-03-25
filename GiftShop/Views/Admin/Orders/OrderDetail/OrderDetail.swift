//  OrderDetail.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI

struct OrderDetail: View {
    
    @ObservedObject var orderDetailVM = OrderDetailVM()
    private let order: Order
    
    init(orderDetailVM: OrderDetailVM, order: Order) {
        self.orderDetailVM = orderDetailVM
        self.order = order
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localization.orderDetails)
                .customTextStyle(TextStyle.avenirRegular, size: 22)
                .fontWeight(.bold)
                .padding([.top, .leading])
            VStack(alignment: .leading, spacing: 10) {
                Text("\(Localization.orderDate) \(Extentions.shared.formattedDate(order.date))")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.status) \(order.status)")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                    .foregroundColor(Extentions.shared.statusColor(for: order.status))
                Text("\(Localization.promoCode): \(order.promocode)")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 10) {
                Text(Localization.goods)
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                    .bold()
                ForEach(order.positions) { position in
                    HStack {
                        Text("\(Localization.title) \(position.product.name): \(position.count) \(Localization.amount).")
                            .customTextStyle(TextStyle.avenirRegular, size: 16)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 5)
            VStack(alignment: .leading, spacing: 10) {
                Text("\(Localization.name): \(orderDetailVM.userProfile?.name ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.email) \(orderDetailVM.userProfile?.email ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.deliveryAddress) \(orderDetailVM.userProfile?.address ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.phoneNumber) \(orderDetailVM.userProfile?.phone ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.sum) \(order.cost) \(Localization.som)")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top)
            }
            .padding(.leading)
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



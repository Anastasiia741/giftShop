//  OrderDetail.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI

struct OrderDetail: View {
    
    @ObservedObject var viewModel = OrderDetailVM()
    @StateObject var statusColors = StatusColors()
    private let order: Order
    @State private var isShowingStatusAlert = false

    
    init(orderDetailVM: OrderDetailVM, order: Order) {
        self.viewModel = orderDetailVM
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
                HStack {
                    Text(Localization.status)
                        .customTextStyle(TextStyle.avenir, size: 18)
                    Text(order.status)
                        .customTextStyle(TextStyle.avenir, size: 18)
                        .foregroundColor(statusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
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
                Text("\(Localization.name): \(viewModel.userProfile?.name ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.email) \(viewModel.userProfile?.email ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.deliveryAddress) \(viewModel.userProfile?.address ?? "")")
                    .customTextStyle(TextStyle.avenirRegular, size: 18)
                Text("\(Localization.phoneNumber) \(viewModel.userProfile?.phone ?? "")")
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
            isShowingStatusAlert = true
        }) {
            Text("\(viewModel.selectedOrder?.status ?? "")")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .frame(maxWidth: 130, minHeight: 50)
                .foregroundColor(.white)
                .background(Color(.green))
                .cornerRadius(20)
                .shadow(color: Color(.green).opacity(0.5), radius: 5, x: 0, y: 5)
        }
        .actionSheet(isPresented: $isShowingStatusAlert) {
            ActionSheet(
                title: Text(Localization.selectOrderStatus),
                buttons: [
                    .default(Text(OrderStatus.new.rawValue)) {
                        viewModel.updateOrderStatus(orderID: order.id, newStatus: OrderStatus.new.rawValue)
                    },
                    .default(Text(OrderStatus.processing.rawValue)) {
                        viewModel.updateOrderStatus(orderID: order.id, newStatus: OrderStatus.processing.rawValue)
                    },
                    .default(Text(OrderStatus.shipped.rawValue)) {
                        viewModel.updateOrderStatus(orderID: order.id, newStatus: OrderStatus.shipped.rawValue)
                    },
                    .default(Text(OrderStatus.delivered.rawValue)) {
                        viewModel.updateOrderStatus(orderID: order.id, newStatus: OrderStatus.delivered.rawValue)
                    },
                    .default(Text(OrderStatus.cancelled.rawValue)) {
                        viewModel.updateOrderStatus(orderID: order.id, newStatus:OrderStatus.cancelled.rawValue)
                    },
                    .cancel()
                ]
            )
        }
        .padding(.bottom, 22)
    }
}



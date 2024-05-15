//  OrderCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI

struct OrderCell: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var order: Order
    @StateObject var orderDetailVM: OrderDetailVM = OrderDetailVM()
    @StateObject var statusColors = StatusColors()
    @State private var isOrderDetailActive = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(Localization.dateOf) \(Extentions().formattedDate(order.date))")
                    .customTextStyle(TextStyle.avenir, size: 18)
                HStack {
                    Text(Localization.status)
                        .customTextStyle(TextStyle.avenir, size: 18)
                    Text(order.status)
                        .customTextStyle(TextStyle.avenir, size: 18)
                        .foregroundColor(statusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
            }
            Spacer()
            Button(action: {
                isOrderDetailActive = true
                orderDetailVM.selectedOrder = order
                Task {
                    await orderDetailVM.fetchUserProfile()
                }
            }) {
                Text(Localization.moreDetails)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .frame(maxWidth: 100, minHeight: 30)
                    .foregroundColor(.white)
                    .background(Color(.green))
                    .cornerRadius(20)
                    .shadow(color: Color(.green).opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $isOrderDetailActive) {
                OrderDetail(orderDetailVM: orderDetailVM)
            }
        }
    }
}



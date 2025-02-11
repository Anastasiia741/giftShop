//  OrderCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI

struct OrderCell: View {
    @StateObject var orderDetailVM = OrderDetailVM()
    private let textComponent = TextComponent()
    @Binding var order: Order
    @State private var isShowOrderDetail = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                textComponent.createText(text: "\(Localization.dateOf) \(Extentions().formattedDate(order.date))", fontSize: 16, fontWeight: .regular, color: .black)
                    .padding(.top, 6)
               
                HStack {
                    textComponent.createText(text: Localization.status, fontSize: 16, fontWeight: .regular, color: .black)
                   
                    textComponent.createText(text: order.status, fontSize: 16, fontWeight: .regular, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
                .padding(.top, 6)
            }
        }
        
        Spacer()
        Button(action: {
            isShowOrderDetail = true
            orderDetailVM.selectOrder = order
            Task {
                await orderDetailVM.fetchUserProfile()
            }
        }) {
            textComponent.createText(text: Localization.moreDetails, fontSize: 14, fontWeight: .regular, color: .white)
                .frame(maxWidth: 100, minHeight: 30)
                .background(Color(StatusColor.new))
                .cornerRadius(20)
                .shadow(color: Color(StatusColor.new).opacity(0.3), radius: 3, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowOrderDetail) {
            OrderDetail(orderDetailVM: orderDetailVM, orderVM: OrdersVM())
        }
    }
}



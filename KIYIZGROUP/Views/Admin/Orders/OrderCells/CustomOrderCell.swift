//  CustomOrderCell.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 7/2/25.

import SwiftUI

struct CustomOrderCell: View {
    @ObservedObject var ordersVM = OrdersVM()
    @State private var selectedOrder: CustomOrder?
    @Binding var order: CustomOrder
    private let textComponent = TextComponent()
    @State private var isShowOrderDetail = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                textComponent.createText(text: "\(Localization.dateOf) \(Extentions().formattedDate(order.date))", fontSize: 16, fontWeight: .regular, color: .black)
                    .padding(.top, 6)
                HStack {
                    textComponent.createText(text: "Название: ", fontSize: 16, fontWeight: .regular, color: .black)
                    
                    textComponent.createText(text: order.product?.name ?? "не указано", fontSize: 16, fontWeight: .regular, color: .black)
                }
                .padding(.top, 6)
                
                HStack {
                    textComponent.createText(text: Localization.status, fontSize: 16, fontWeight: .regular, color: .black)
                    textComponent.createText(text: order.status, fontSize: 16, fontWeight: .regular, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
                .padding(.top, 6)
            }
            Spacer()
            Button(action: {
                selectedOrder = order
                isShowOrderDetail = true
            }) {
                textComponent.createText(text: Localization.moreDetails, fontSize: 14, fontWeight: .regular, color: .white)
                    .frame(maxWidth: 100, minHeight: 30)
                    .background(Color(StatusColor.new))
                    .cornerRadius(20)
                    .shadow(color: Color(StatusColor.new).opacity(0.3), radius: 3, x: 0, y: 3)
            }
            .sheet(isPresented: $isShowOrderDetail) {
                if let selectedOrder = selectedOrder {
                    CustomOrderDetail(order: selectedOrder)
                } else {
                    Text("Ошибка: заказ не найден.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}


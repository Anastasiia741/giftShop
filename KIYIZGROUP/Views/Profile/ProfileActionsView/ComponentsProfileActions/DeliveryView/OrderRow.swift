//  OrderRow.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/1/25.

import SwiftUI

struct OrderRow: View {
    let order: Order
    let statusColors: StatusColors
    let textComponent: TextComponent
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                textComponent.createText(text: "Статус заказа", fontSize: 14, fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: order.status, fontSize: 14, fontWeight: .bold,
                                         lightColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new),
                                         darkColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
            }
            .padding(.vertical, 6)
           
            HStack {
                textComponent.createText(text: "Номер заказа", fontSize: 14,fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: "\(order.id.prefix(6))", fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            .padding(.vertical, 6)
           
            HStack {
                textComponent.createText(text: "Дата и время заказа", fontSize: 14, fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: Extentions().formattedDate(order.date), fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            .padding(.vertical, 6)
            CustomDivider()
           
            HStack {
                Spacer()
                textComponent.createText(text: "Сумма: \(order.cost) сом", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            .padding(.vertical, 6)
        }
        .padding()
        .adaptiveFill()
        .adaptiveOverlay()
        .padding(.vertical, 4)
    }
}


struct CustomOrderRow: View {
    let order: CustomOrder
    let statusColors: StatusColors
    let textComponent: TextComponent
    let designImage: [String: URL] 
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                textComponent.createText(text: "Статус заказа", fontSize: 14, fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: order.status, fontSize: 14, fontWeight: .bold,
                                         lightColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new),
                                         darkColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
            }
            .padding(.vertical, 6)
            
            HStack {
                textComponent.createText(text: "Номер заказа", fontSize: 14,fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: "\(order.id.prefix(6))", fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            .padding(.vertical, 6)
            
            HStack {
                textComponent.createText(text: "Товар", fontSize: 14, fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: order.product?.name ?? "", fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            .padding(.vertical, 6)
        
            HStack {
                textComponent.createText(text: "Дизайн", fontSize: 14, fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                       Spacer()
                       
                       if let imageURL = designImage[order.id] {
                           AsyncImage(url: imageURL) { image in
                               image.resizable()
                                   .scaledToFit()
                                   .frame(width: 50, height: 50)
                                   .clipShape(RoundedRectangle(cornerRadius: 8))
                           } placeholder: {
                               ProgressView()
                                   .frame(width: 50, height: 50)
                           }
                       } else {
                           ZStack {
                               RoundedRectangle(cornerRadius: 8)
                                   .fill(Color.gray.opacity(0.2))
                                   .frame(width: 50, height: 50)
                               textComponent.createText(text: "Нет", fontSize: 12, fontWeight: .bold, lightColor: .gray, darkColor: .white)
                           }
                       }
                   }
                   .padding(.vertical, 6)
            
        
            HStack {
                textComponent.createText(text: "Дата и время заказа", fontSize: 14, fontWeight: .semibold, lightColor: .gray, darkColor: .white)
                Spacer()
                textComponent.createText(text: Extentions().formattedDate(order.date), fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
                Spacer()
            }
            .padding(.vertical, 6)
        }
        .padding()
        .adaptiveFill()
        .adaptiveOverlay()
        .padding(.vertical, 4)
    }
}


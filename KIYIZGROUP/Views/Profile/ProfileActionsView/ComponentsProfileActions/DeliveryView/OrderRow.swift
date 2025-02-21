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
                textComponent.createText(text: order.status, fontSize: 14, fontWeight: .bold, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
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
            CustomDivider()
           
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


struct CustomOrderRow: View {
    let order: CustomOrder
    let colorScheme: ColorScheme
    let statusColors: StatusColors
    let textComponent: TextComponent
    let designImage: [String: URL] 
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                textComponent.createText(text: "Статус заказа", fontSize: 14, fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: order.status, fontSize: 14, fontWeight: .bold, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
            }
            .padding(.vertical, 6)
            
            HStack {
                textComponent.createText(text: "Номер заказа", fontSize: 14,fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: "\(order.id.prefix(6))", fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding(.vertical, 6)
            
            HStack {
                textComponent.createText(text: "Товар", fontSize: 14, fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: order.product?.name ?? "", fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding(.vertical, 6)
        
            HStack {
                       textComponent.createText(text: "Дизайн", fontSize: 14, fontWeight: .semibold, color: .gray)
                       Spacer()
                       
                       if let imageURL = designImage[order.id] {
                           AsyncImage(url: imageURL) { image in
                               image.resizable()
                                   .scaledToFit()
                                   .frame(width: 50, height: 50) // Фиксированный размер
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
                               textComponent.createText(text: "Нет", fontSize: 12, fontWeight: .bold, color: .gray)
                           }
                       }
                   }
                   .padding(.vertical, 6)
            
        
            HStack {
                textComponent.createText(text: "Дата и время заказа", fontSize: 14, fontWeight: .semibold, color: .gray)
                Spacer()
                textComponent.createText(text: Extentions().formattedDate(order.date), fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
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


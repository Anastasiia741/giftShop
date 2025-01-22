//  DetailView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var certViewModel = CartVM()
    @StateObject var viewModel: ProfileVM
    @StateObject var statusColors = StatusColors()
    private let textComponent = TextComponent()
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "Детали", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.vertical)
            VStack {
                HStack {
                    textComponent.createText(text: Localization.status, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(order.status)", fontSize: 16, fontWeight: .regular, color: statusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
                HStack {
                    textComponent.createText(text: "Номер заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "12345", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    
                }
                .padding([.vertical])
                HStack {
                    textComponent.createText(text: "Дата и время заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(Extentions().formattedDate(order.date))", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                Divider()
                    .padding(.horizontal)
                    .background(Color.gray)
                HStack {
                    textComponent.createText(text: "Адрес доставки", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(viewModel.address)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                .padding(.top)
                HStack {
                    textComponent.createText(text: "Телефон", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(viewModel.phone)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                .padding(.top)
                Divider()
                    .padding(.horizontal)
                    .background(Color.gray)
                HStack {
                    textComponent.createText(text: "Сумма заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(order.cost) сом", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                .padding(.vertical)
                HStack {
                    textComponent.createText(text: "Доставка", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "Бесплатно", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
        .padding(.horizontal)
    }
}

//  DetailView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var cartViewModel = CartVM()
    @StateObject var viewModel: ProfileVM
//    @StateObject var statusColors = StatusColors()
    private let statusColors = StatusColors() // ✅ Correct

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
                    textComponent.createText(text: "\(order.status)", fontSize: 16, fontWeight: .regular, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
                HStack {
                    textComponent.createText(text: "Номер заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(order.id.prefix(6))", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    
                }
                .padding([.vertical])
                HStack {
                    textComponent.createText(text: "Дата и время заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(Extentions().formattedDate(order.date))", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                CustomDivider()
           
                HStack {
                    textComponent.createText(text: "Адрес доставки", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(order.address)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                .padding(.top)
                HStack {
                    textComponent.createText(text: "Телефон", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    textComponent.createText(text: "\(order.phone)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
                .padding(.top)
                CustomDivider()

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
        .onAppear {
                   Task {
                       if viewModel.authService.currentUser == nil {
                           cartViewModel.fetchGuestData()
                       } else {
                           cartViewModel.fetchOrder()
                           await viewModel.fetchUserProfile()
                       }
                   }
               }
        .padding(.horizontal)
    }
}

//  DetailView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct DetailView: View {
    @StateObject private var cartViewModel = CartVM()
    @StateObject var viewModel: ProfileVM
    private let statusColors = StatusColors()
    
    private let textComponent = TextComponent()
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "details".localized, fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                .padding(.vertical)
            VStack {
                HStack {
                    textComponent.createText(text: "status".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(order.status)", fontSize: 16, fontWeight: .regular,
                                             lightColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new),
                                             darkColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                    
                }
                HStack {
                    textComponent.createText(text: "order_number".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(order.id.prefix(6))", fontSize: 16, fontWeight: .regular,  lightColor: .black, darkColor: .white)
                }
                .padding([.vertical])
                HStack {
                    textComponent.createText(text: "date_and_time_of_order".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(Extentions().formattedDate(order.date))", fontSize: 16, fontWeight: .regular,  lightColor: .black, darkColor: .white)
                }
                CustomDivider()
                
                HStack {
                    textComponent.createText(text: "your_delivery_address".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(order.address)", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                }
                .padding(.top)
                HStack {
                    textComponent.createText(text: "phone".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(order.phone)", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                }
                .padding(.top)
                CustomDivider()
                
                HStack {
                    textComponent.createText(text: "order_amount".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(order.cost) \("com".localized)", fontSize: 16, fontWeight: .regular,  lightColor: .black, darkColor: .white)
                }
                .padding(.vertical)
                HStack {
                    textComponent.createText(text: "delivery".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "for_free".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                }
            }
            .padding()
            .adaptiveStroke()
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

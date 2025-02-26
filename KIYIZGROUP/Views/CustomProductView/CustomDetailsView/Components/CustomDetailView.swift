//  CustomDetailView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct CustomDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: CustomProductVM
    private let statusColors = StatusColors()
    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView
            orderDetails
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
                .onAppear(){
                }
        }
    }
    
    private var headerView: some View {
        textComponent.createText(text: "Детали", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
        .padding(.vertical)
    }
    
    private var orderDetails: some View {
        VStack(spacing: 16) {
            detailRow(label: Localization.status, value: "\(customOrder.status)", valueColor: StatusColors.getTextColor(OrderStatus(rawValue: customOrder.status) ?? .new))
           
            detailRow(label: "Номер заказа", value: "\(customOrder.id.prefix(6))")
           
            detailRow(label: "Дата и время заказа", value: Extentions().formattedDate(customOrder.date))
           
            CustomDivider()
            
            detailRow(label: "Телефон", value: viewModel.phone)
        }
    }
    
    private func detailRow(label: String, value: String, valueColor: Color? = nil) -> some View {
        HStack {
            textComponent.createText(text: label, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            Spacer()
           
            textComponent.createText(text: value, fontSize: 16, fontWeight: .regular, color: valueColor ?? (colorScheme == .dark ? .white : .black))
        }
    }
}

//  CustomDetailView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct CustomDetailView: View {
    @ObservedObject var viewModel: CustomProductVM
    private let statusColors = StatusColors()
    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView
            orderDetails
                .padding()
                .adaptiveStroke()
        }
    }
    
}

private extension CustomDetailView {
    
    var headerView: some View {
        textComponent.createText(text: "details".localized, fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
            .padding(.vertical)
    }
    
    var orderDetails: some View {
        VStack(spacing: 16) {
            detailRow(label: "Статус", value: "\(customOrder.status)", valueColor: StatusColors.getTextColor(OrderStatus(rawValue: customOrder.status) ?? .new))
            
            detailRow(label: "order_number".localized, value: "\(customOrder.id.prefix(6))")
            
            detailRow(label: "date_and_time_of_order".localized, value: Extentions().formattedDate(customOrder.date))
            
            CustomDivider()
            
            detailRow(label: "phone".localized, value: viewModel.phone)
        }
    }
    
    func detailRow(label: String, value: String, valueColor: Color? = nil) -> some View {
        HStack {
            textComponent.createText(text: label, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            Spacer()
            
            textComponent.createText(text: value, fontSize: 16, fontWeight: .regular,    lightColor: valueColor ?? .black, darkColor: valueColor ?? .white)
            
        }
    }
}

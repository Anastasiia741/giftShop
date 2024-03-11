//  ProfileCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 2/2/24.

import SwiftUI

struct ProfileCell: View {
    
    var order: Order
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    @StateObject var statusColors = StatusColors()
    @StateObject var viewModel: ProfileVM
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Сумма: \(order.cost)")
                .font(.custom("AvenirNext-bold", size: 16))
            Text("Дата: \(dateFormatter.string(from: order.date))")
                .font(.custom("AvenirNext", size: 14))
            HStack {
                Text("Статус: ")
                    .font(.custom("AvenirNext", size: 14))
                Text(order.status)
                    .font(.custom("AvenirNext", size: 14))
                    .foregroundColor(statusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
            }
        }
    }
}

#Preview {
    ProfileCell(order: Order(id: "",
                             userID: "",
                             positions: [Position](),
                             date: Date(),
                             status: "",
                             promocode: ""),
                viewModel: ProfileVM.shared)
}

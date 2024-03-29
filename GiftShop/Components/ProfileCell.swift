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
            Text("\(Localization.sum) \(order.cost)")
                .customTextStyle(TextStyle.avenirBold, size: 16)
            Text("\(Localization.dateOf) \(dateFormatter.string(from: order.date))")
                .customTextStyle(TextStyle.avenir, size: 14)
            HStack {
                Text(Localization.status)
                    .customTextStyle(TextStyle.avenir, size: 14)
                Text(order.status)
                    .customTextStyle(TextStyle.avenir, size: 14)
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
                viewModel: ProfileVM())
}

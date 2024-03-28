//  Extentions.swift
//  GiftShop
//  Created by Анастасия Набатова on 7/3/24.

import SwiftUI

final class Extentions: ObservableObject {
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func statusColor(for status: String) -> Color {
        switch status {
        case OrderStatus.new.rawValue:
            return .green
        case OrderStatus.processing.rawValue:
            return .blue
        case OrderStatus.shipped.rawValue:
            return .orange
        case OrderStatus.delivered.rawValue:
            return .green
        case OrderStatus.cancelled.rawValue:
            return .red
        default:
            return .primary
        }
    }
}

extension Text {
    func customTextStyle(_ style: String, size: CGFloat) -> Text {
        font(.custom(style, size: size))
    }
}


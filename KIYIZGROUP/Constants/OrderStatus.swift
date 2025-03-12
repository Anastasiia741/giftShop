//  OrderStatus.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import SwiftUICore
import UIKit

enum OrderStatus: String, CaseIterable {
    case all = "все"
    case new = "новый"
    case processing = "в обработке"
    case shipped = "отправлен"
    case delivered = "доставлен"
    case cancelled = "отменен"
}

enum StatusColor {
    static let new = "New"
    static let inProgress = "InProgress"
    static let sended = "Sended"
    static let delivered = "Delivered"
    static let cancelled = "r"
    static let greenButtom = "New"
}

struct StatusColors {
    static func getTextColor(_ status: OrderStatus) -> Color {
        switch status {
        case .new:
            return Color(UIColor(named: StatusColor.new) ?? .black)
        case .processing:
            return Color(UIColor(named: StatusColor.inProgress) ?? .black)
        case .shipped:
            return Color(UIColor(named: StatusColor.sended) ?? .black)
        case .delivered:
            return Color(UIColor(named: StatusColor.delivered) ?? .black)
        case .cancelled:
            return Color(UIColor(named: StatusColor.cancelled) ?? .black)
        default:
            return Color.black
        }
    }
}

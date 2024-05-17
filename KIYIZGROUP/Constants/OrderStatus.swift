//  OrderStatus.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation

enum OrderStatus: String, CaseIterable {
    case all = "все"
    case new = "новый"
    case processing = "в обработке"
    case shipped = "отправлен"
    case delivered = "доставлен"
    case cancelled = "отменен"
}

enum StatusColor {
    static let new = "NewStatusColor"
    static let inProgress = "InProgressStatusColor"
    static let sended = "SendedStatusColor"
    static let delivered = "DeliveredStatusColor"
    static let cancelled = "CancelledStatusColor"
    static let greenButtom = "GreenButton"
}

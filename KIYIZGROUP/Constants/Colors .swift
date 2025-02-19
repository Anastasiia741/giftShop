//  Colors .swift
//  GiftShop
//  Created by Анастасия Набатова on 14/3/24.

import Foundation
import SwiftUI

enum Colors {
    static let yellow = Color("yelColor")
    static let red = Color("rColor")
    static let brown = Color("bColor")
    static let lightYellow = Color("lightYellowColor")
    static let orange = Color("oColor")
    static let promo = Color("promoButton")
    static let buy = Color("buyButton")
    static let promoCancel = Color("promoCancel")
    static let promoApply = Color("promoApply")
    static let whiteAlfa = Color("whiteAlfa")
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

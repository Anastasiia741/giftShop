//  StatusColors.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI

final class StatusColors: ObservableObject {
        
    func getTextColor(_ status: OrderStatus) -> Color  {
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
            return Color(UIColor(.black))
        }
    }
}

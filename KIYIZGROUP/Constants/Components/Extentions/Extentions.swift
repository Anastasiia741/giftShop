//  Extentions.swift
//  GiftShop
//  Created by Анастасия Набатова on 7/3/24.

import SwiftUI

enum TabType: Int {
    case catalog, cart, profile, auth, productsEdit, createProduct, orders, customOrders
}


extension String {
    var localized: String {
        LanguageManager.shared.localizedString(forKey: self)
    }
}

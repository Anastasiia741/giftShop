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

extension URL {
    func appendingQueryParameter(_ name: String, value: String) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? self
    }
}

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
}

extension Text {
    func customTextStyle(_ style: String, size: CGFloat) -> Text {
        font(.custom(style, size: size))
    }
}

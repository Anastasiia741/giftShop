//  TextExtention.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI

extension Text {
    func customTextStyle(_ style: String, size: CGFloat) -> Text {
        font(.custom(style, size: size))
    }
}

final class Extentions: ObservableObject {
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}


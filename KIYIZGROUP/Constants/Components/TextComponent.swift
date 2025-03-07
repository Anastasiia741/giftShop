//  TextComponent.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

final class Extentions: ObservableObject {
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}

struct TextComponent {
    func createText(text: String, fontSize: CGFloat, fontWeight: Font.Weight, style: Font.TextStyle? = nil, lightColor: Color, darkColor: Color) -> some View {
        Text(text)
            .font(
                style != nil
                ? Font.system(style!)
                : Font.custom("Inter", size: fontSize)
            )
            .fontWeight(fontWeight)
            .adaptiveForeground(light: lightColor, dark: darkColor)
    }
}


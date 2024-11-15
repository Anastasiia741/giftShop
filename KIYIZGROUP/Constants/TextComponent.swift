//  TextComponent.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

struct TextComponent {

    func createText(text: String, fontSize: CGFloat, fontWeight: Font.Weight, color: Color) -> some View {
        Text(text)
            .font(.custom("Inter", size: fontSize))
            .fontWeight(fontWeight)
            .foregroundColor(color)
    }
}


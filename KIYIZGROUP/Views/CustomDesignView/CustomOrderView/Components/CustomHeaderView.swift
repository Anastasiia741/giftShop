//  CustomHeaderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct CustomHeaderView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    var title: String
    
    var body: some View {
        HStack{
            textComponent.createText(text: title, fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.bottom, 4)
            Spacer()
        }
        .padding()
    }
}


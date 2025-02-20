//  CustomDesignSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CustomDesignSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let customOrder: CustomOrder

    var body: some View {
        VStack(alignment: .leading ) {
            textComponent.createText(text: Localization.customDesign, fontSize: 21, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                .padding(.leading, 30)
            CustomDesignView(customOrder: customOrder)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}



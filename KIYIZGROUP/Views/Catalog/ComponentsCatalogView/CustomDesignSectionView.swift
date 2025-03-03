//  CustomDesignSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CustomDesignSectionView: View {
    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    @Binding var currentTab: Int

    var body: some View {
        VStack(alignment: .leading ) {
            textComponent.createText(text: Localization.customDesign, fontSize: 21, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                .padding(.leading, 30)
            CustomDesignView(customOrder: customOrder, currentTab: $currentTab)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}



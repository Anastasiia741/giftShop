//  CustomDesignSectionView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CustomDesignSectionView: View {
    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    @Binding var currentTab: Int
    @Binding var showCustomView: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showCustomView.toggle()
            }) {
                HStack {
                    textComponent.createText(text: Localization.makeCustomOrder, fontSize: 16, fontWeight: .bold, lightColor: .white, darkColor: .white)
                    Spacer()
                    Images.Menu.chevron
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 362, height: 72)
                .background(.colorGreen)
                .cornerRadius(24)
            }
        }
        .padding()
    }
}



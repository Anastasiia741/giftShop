//  CustomDesignView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

struct CustomDesignView: View {
    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    @Binding var currentTab: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            NavigationLink(destination: CustomView(customOrder: customOrder, currentTab: $currentTab)) {
                HStack {
                    textComponent.createText(text: Localization.makeCustomOrder, fontSize: 16, fontWeight: .bold, color: .white)
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


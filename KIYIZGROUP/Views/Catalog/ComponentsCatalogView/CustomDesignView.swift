//  CustomDesignView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 12/11/24.

import SwiftUI

struct CustomDesignView: View {
    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    @Binding var currentTab: Int
    @State private var showCustomView = false
    @State var email: String = ""
    @State private var isViewActive = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                showCustomView = true
            }) {
                HStack {
                    textComponent.createText(text: "make_custom_order".localized, fontSize: 16, fontWeight: .bold, lightColor: .white, darkColor: .white)
                    Spacer()
                    Images.Menu.chevron
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 362, height: 72)
                .background(.colorGreen)
                .cornerRadius(24)
            }
            
            .navigationDestination(isPresented: $showCustomView) {
                CustomView(customOrder: customOrder, currentTab: $currentTab)
            }
        }
        .padding()
    }
}


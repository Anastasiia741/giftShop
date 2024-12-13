//  ProductInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct ProductInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let productDetail: String
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                textComponent.createText(text: "О товаре", fontSize: 14, fontWeight: .regular, color: .colorLightBrown)
                ScrollView {
                    textComponent.createText(text: "\(productDetail)", fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
            }
            .padding([.top, .bottom], 20)
            
            .background(Color.white)
        }
        .padding(.top, 20)
        .padding(.horizontal)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(RoundedRectangle(cornerRadius: 40)
            .stroke(Color.gray, lineWidth: 1.5)
        )
    }
}

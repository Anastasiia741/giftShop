//  PopularProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 26/1/24.

import SwiftUI
import FirebaseStorage

struct PopularProductCell: View {
    private let textComponent = TextComponent()
    @State private var imageURL: URL?
    let product: Product
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(.colorDarkBrown)
                    .frame(width: 224, height: 224)
                    .position(x: 294, y: 102)
                VStack(alignment: .leading, spacing: 8) {
                    textComponent.createText(text: product.localizedValue(for: product.name), fontSize: 16, fontWeight: .bold, lightColor: .white, darkColor: .white)
                        .padding(.top, 16)
                        .padding(.leading, 8)
                    textComponent.createText(text: "\(product.price) \("som".localized)", fontSize: 16, fontWeight: .bold, lightColor: .white, darkColor: .white)
                        .padding(.top, 22)
                        .padding(.leading, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 344, height: 129)
        .background(.colorLightBrown)
        .cornerRadius(24)
        .shadow(radius: 2)
    }
}




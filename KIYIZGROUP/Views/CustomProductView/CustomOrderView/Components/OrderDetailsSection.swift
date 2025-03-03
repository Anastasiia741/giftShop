//  OrderDetailsSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct OrderDetailsSection: View {
    private let textComponent = TextComponent()
    var productType: String
    var comment: String
    var designImage: UIImage?
    var addedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 12) {
            HStack{
                textComponent.createText(text: "Заказ", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                Spacer()
            }
            .padding()
            
            VStack{
                HStack {
                    textComponent.createText(text: "Тип товара", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: productType, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                }
                .padding(.vertical, 4)
                HStack {
                    textComponent.createText(text: "Дизайн", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    Spacer()
                    
                    if let image = designImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    ColorManager.adaptiveColor(light: Color.gray.opacity(0.3), dark: Color.white.opacity(0.2)),
                                    lineWidth: 1
                                )
                                .frame(width: 40, height: 40)
                            textComponent.createText(text: "нет", fontSize: 12, fontWeight: .regular, lightColor: .black, darkColor: .white)
                        }
                    }
                }
                .padding(.vertical, 4)
                
                HStack {
                    textComponent.createText(text: "Добавленное фото", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    
                    Spacer()
                    
                    if let image = addedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(ColorManager.adaptiveColor(light: Color.gray.opacity(0.3), dark: Color.white.opacity(0.2)), lineWidth: 1)
                                .frame(width: 40, height: 40)
                            textComponent.createText(text: "нет", fontSize: 12, fontWeight: .regular, lightColor: .black, darkColor: .white)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorManager.adaptiveColor(light: Color.gray.opacity(0.3), dark: Color.white.opacity(0.2)), lineWidth: 1)
            )
            
            VStack(alignment: .leading) {
                textComponent.createText(text: "Комментарий", fontSize: 16, fontWeight: .regular, lightColor: .gray, darkColor: .gray)
                    .padding(.vertical, 4)
                textComponent.createText(text: comment, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorManager.adaptiveColor(light: Color.gray.opacity(0.3), dark: Color.white.opacity(0.2)), lineWidth: 1.5)
            )
        }
    }
}


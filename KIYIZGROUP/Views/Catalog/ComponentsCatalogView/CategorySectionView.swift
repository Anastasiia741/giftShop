//  CategorySectionView 2.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CategorySectionView: View {
    @Binding var selectedCategory: String
    private let textComponent = TextComponent()
    let onCategorySelected: (String) -> Void
    let categories: [String]
    let showText: Bool
    
    var body: some View {
        VStack(alignment: .leading ) {
            if showText {
                textComponent.createText(text: Localization.products, fontSize: 21, fontWeight: .heavy, lightColor: .black, darkColor: .white)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            onCategorySelected(category)
                        }) {
                            textComponent.createText(text: category, fontSize: 17, fontWeight: .medium,
                                                     lightColor: selectedCategory == category ? .white : .black,
                                                     darkColor: selectedCategory == category ? .white : .white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(selectedCategory == category ? .colorDarkBrown : .clear)
                            .cornerRadius(20)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(.colorYellow, lineWidth: 1)
                            .opacity(selectedCategory == category ? 0 : 1)
                        )
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .padding(.leading, 20)
    }
}

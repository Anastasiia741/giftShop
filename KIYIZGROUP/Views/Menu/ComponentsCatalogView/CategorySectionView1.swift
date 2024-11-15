//  CategorySectionView 2.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CategorySectionView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedCategory: String
    private let textComponent = TextComponent()
    let onCategorySelected: (String) -> Void
    let categories: [String]
    
    var body: some View {
        VStack(alignment: .leading ) {
            textComponent.createText(text: Localization.products, fontSize: 21, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                .padding(.leading, 30)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                            onCategorySelected(category)
                        }) {
                            textComponent.createText(text: category, fontSize: 17, fontWeight: .medium, color: selectedCategory == category ? .white : (colorScheme == .dark ? .white : .black))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedCategory == category ? .colorDarkBrown : .white)
                                .cornerRadius(20)
                        }
                        .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("ColorYellow"), lineWidth: 1)
                            .opacity(selectedCategory == category ? 0 : 1)
                        )
                    }
                }
                .padding(.leading, 30)
                .padding(.vertical, 10)
            }
        }
        .padding(.leading, 20)
    }
}

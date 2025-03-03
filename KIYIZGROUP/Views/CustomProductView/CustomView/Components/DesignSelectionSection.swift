//  DesignSelectionSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI
import PhotosUI

struct DesignSelectionSection: View {
    @ObservedObject var viewModel: CustomProductVM
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerSection()
            styleSelectionScrollView()
        }
        .padding(.vertical)
        .onAppear {
            Task {
                await viewModel.fetchCustomProduct()
            }
        }
    }
    
    private func headerSection() -> some View {
        textComponent.createText(text: "Выберите стиль", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
    }
}

extension DesignSelectionSection {
    private func styleSelectionScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.allCustomStyles, id: \.id) { style in
                    StyleItemView(viewModel: viewModel, style: style, isSelected: viewModel.selectedStyle?.id == style.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3)) {
                            viewModel.selectedStyle = style
                        }
                    }
                }
            }
        }
    }
}





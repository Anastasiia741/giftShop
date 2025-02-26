//  StyleItemView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 5/2/25.

import SwiftUI
import Kingfisher

struct StyleItemView: View {
    @ObservedObject var viewModel: CustomProductVM
    var style: CustomStyle
    var isSelected: Bool
    
    var body: some View {
        VStack() {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 60, height: 60)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: isSelected)
                if let imageURL = viewModel.styleURLs[style.id] {
                    KFImage(imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(16)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: isSelected)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.colorDarkBrown : Color.clear, lineWidth: 1.3)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: isSelected)
            )
        }
        .padding(.vertical)
    }
}

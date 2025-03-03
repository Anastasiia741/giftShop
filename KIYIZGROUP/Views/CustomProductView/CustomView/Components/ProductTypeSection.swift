//  ProductTypeSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI
import Kingfisher

struct ProductTypeSection: View {
    @StateObject var viewModel: CustomProductVM
    private let textComponent = TextComponent()
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textComponent.createText(text: "Тип товара", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.allCustomProducts, id: \.id) { product in
                        productView(for: product)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3)) {
                                    viewModel.selectedProduct = product
                                }
                            }
                    }
                }
                .onAppear {
                    Task {
                        await viewModel.fetchCustomProduct()
                    }
                }
            }
        }
    }
}


extension ProductTypeSection {
    private func productView(for product: CustomProduct) -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        viewModel.selectedProduct?.id == product.id ? Color.colorDarkBrown : Color.clear,
                        lineWidth: 1.3
                    )
                    .scaleEffect(viewModel.selectedProduct?.id == product.id ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.selectedProduct?.id)
                
                if let imageURL = viewModel.deisignURLs[product.id] {
                    KFImage(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .cornerRadius(16)
                        .scaleEffect(viewModel.selectedProduct?.id == product.id ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.selectedProduct?.id)
                }
            }
            .frame(width: 87, height: 101)
            
            textComponent.createText(text: product.name, fontSize: 12, fontWeight: .regular, lightColor: .black, darkColor: .white)
            .padding(.top, 4)
        }
        .padding(.vertical)
        .padding(.horizontal, 2)
    }
}



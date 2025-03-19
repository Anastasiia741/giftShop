//  ProductDetailView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ProductDetailVM
    private let textComponent = TextComponent()
    private let buttonComponent = ButtonComponents()
    @State var count = 1
    let currentUserId: String
    @Binding var currentTab: Int
    @State private var isShowCart = false
    @State private var isAddedToCart = false
    
    var body: some View {
        VStack {
            KFImage(viewModel.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 345)
                .clipped()
                .cornerRadius(24)
                .padding(.bottom)
                .overlay(
                    HStack {
                        CustomBackButton()
                            .padding([.leading, .top], 16)
                        Spacer()
                    },
                    alignment: .topLeading
                )
            HStack() {
                textComponent.createText(text: "\(viewModel.product.price) \("som".localized)", fontSize: 21, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                fullPriceView()
            }
            .padding([.vertical, .horizontal])
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: 572)
        .background(Color.colorDarkBrown)
        .cornerRadius(24)
        
        ProductInfoView(productDetail: viewModel.product.detail)
        VStack {
            HStack(spacing: 16) {
                buttonComponent.createWhiteButton(text: "buy_now".localized, isAddedToCart: $isAddedToCart) {
                    let product = Product(
                        id: viewModel.product.id,
                        name: viewModel.product.name,
                        category: viewModel.product.category,
                        detail: viewModel.product.detail,
                        price: viewModel.product.price,
                        fullPrice: viewModel.product.fullPrice ?? 0,
                        image: viewModel.product.image,
                        quantity: count
                    )
                    viewModel.addProductToCart(product)
                    DispatchQueue.main.async {
                        currentTab = TabType.cart.rawValue
                    }
                }
                .background(colorScheme == .dark ? .colorDarkBrown : .white)
                .cornerRadius(40)
                
                buttonComponent.createGreenButton(text: "add_to_cart".localized, count: $count,isAddedToCart: $isAddedToCart) {
                    let product = Product(
                        id: viewModel.product.id,
                        name: viewModel.product.name,
                        category: viewModel.product.category,
                        detail: viewModel.product.detail,
                        price: viewModel.product.price,
                        fullPrice: viewModel.product.fullPrice ?? 0,
                        image: viewModel.product.image,
                        quantity: count
                    )
                    viewModel.addProductToCart(product)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            viewModel.updateImageDetail()
        }
        .onChange(of: currentTab) { _, _ in
            dismiss()
        }
    }
}

private extension ProductDetailView {
    @ViewBuilder
    func fullPriceView() -> some View {
        if let fullPrice = viewModel.product.fullPrice, fullPrice > 0 {
            textComponent.createText(text: "\(fullPrice) \("som".localized)", fontSize: 16, fontWeight: .heavy, lightColor: .gray, darkColor: .gray)
                .strikethrough()
        }
    }
}


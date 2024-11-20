//  ProductDetailView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
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
            VStack {
                WebImage(url: viewModel.imageURL )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .cornerRadius(24)
                    .frame(maxWidth: .infinity, maxHeight: 445)
                HStack() {
                    textComponent.createText(text: "\(viewModel.product.price) \(Localization.som)", fontSize: 21, fontWeight: .heavy, color: .white)
                    
                    textComponent.createText(text: "\("1000") \(Localization.som)", fontSize: 16, fontWeight: .heavy, color: .colorYellow).strikethrough()
                }
                .padding([.top, .bottom])
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: 572)
            .background(Color.colorDarkBrown)
            .cornerRadius(24)
            .padding()
            
            
            ProductInfoView(productDetail: viewModel.product.detail)
                .padding(.top, 30)
                .padding(.bottom, 30)
            
            VStack {
                Spacer()
                HStack(spacing: 16) {
                    
                    buttonComponent.createWhiteButton(
                        text: "Купить сейчас",
                        isAddedToCart: $isAddedToCart) {
                            let product = Product(
                                id: viewModel.product.id,
                                name: viewModel.product.name,
                                category: viewModel.product.category,
                                detail: viewModel.product.detail,
                                price: viewModel.product.price,
                                image: viewModel.product.image,
                                quantity: count
                            )
                            viewModel.addProductToCart(product)
                            DispatchQueue.main.async {
                                currentTab = TabType.cart.rawValue
                            }
                            
                        }
                        .background(colorScheme == .dark ? Color("ColorDarkBrown") : .white)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .cornerRadius(40)
                    
                    buttonComponent.createGreenButton(
                        text: "Добавить в корзину",
                        count: $count,
                        isAddedToCart: $isAddedToCart) {
                            let product = Product(
                                id: viewModel.product.id,
                                name: viewModel.product.name,
                                category: viewModel.product.category,
                                detail: viewModel.product.detail,
                                price: viewModel.product.price,
                                image: viewModel.product.image,
                                quantity: count
                            )
                            viewModel.addProductToCart(product)
                        }
                }
                .padding()
                .background(.clear)
            }
        }
        .onAppear {
            viewModel.updateImageDetail()
        }
    }
}




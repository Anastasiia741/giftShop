//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = CartVM()
    @StateObject private var catalogVM = CatalogVM()
    @Binding var currentTab: Int
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 1.8))]
    private let buttonComponents = ButtonComponents()
    let currentUserId: String
    @State private var promo: String = ""
    @State private var isPresented = false
    @State private var orderPlaced = false
    @State private var isPromoSheetVisible = false
    @State private var isPromoCodeEntryPresented = false
    @State private var navigateToCatalog = false
    @State private var isAuthViewPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.orderProducts.isEmpty {
                    VStack {
                        if orderPlaced {
                            VStack {
                                Text(Localization.thanksForOrder)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Images.Cart.happyCart
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 130)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.clear)
                                Text(Localization.cardOrder)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Text(Localization.emptyСart)
                                .font(.headline)
                                .foregroundColor(.gray)
                            Images.Cart.emptyCart
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 130)
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                            Text(Localization.addItemsToCart)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.orderProducts) { product in
                                CartCell(viewModel: viewModel, position: product)
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                    }
                    
                    buttonComponents.createOrderButton(amount: "\(viewModel.productCountMessage)") {
                        navigateToCatalog = true
                    }
                    
                    
                    .padding(.bottom, 12)
                }
            }
            
            .navigationTitle(Localization.cart)
            
            .navigationBarTitleDisplayMode(.inline)
            
            .navigationDestination(isPresented: $navigateToCatalog) {
                CartOrdersView()
            }
        }
        .onAppear {
            viewModel.fetchOrder()
            Task {
                await catalogVM.fetchAllProducts()
            }
        }
    }
}






//                        if viewModel.orderProducts.isEmpty {
//                            navigateToCatalog = true
//                        } else {
//                            if !currentUserId.isEmpty {
//                                viewModel.orderButtonTapped(with: promo)
//                                orderPlaced = true
//                            } else {
//                                currentTab = 2
//                            }
//                        }




//                    Text(Localization.addToOrder)
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(.gray)
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHGrid(rows: layoutForPopular, spacing: 16) {
//                            ForEach(catalogVM.popularProducts, id: \.id) { item in
//                                PopularProductCell(product: item)
//                                    .foregroundColor(colorScheme == .dark ? .white : .black)
//                                    .onTapGesture {
//                                        viewModel.addPromoProductToOrder(for: item)
//                                    }
//                            }
//                        }.padding(.vertical, 8)
//                    }






//                    Section {
//                        HStack(spacing: 24) {
//                            Text(Localization.getDiscount).font(.system(size: 16, weight: .bold))
//                                .lineLimit(1)
//                                .minimumScaleFactor(0.7)
//                                .truncationMode(.tail)
//                            Spacer()
//                            Button(action: {
//                                isPromoSheetVisible.toggle()
//                            }) {
//                                Text(Localization.promoCode)
//                                    .font(.body)
//                                    .fontWeight(.bold)
//                                    .frame(maxWidth: 130, minHeight: 35)
//                                    .foregroundColor(.white)
//                                    .background(Colors.promo)
//                                    .cornerRadius(20)
//                                    .shadow(color: Colors.promo.opacity(0.5), radius: 5, x: 0, y: 5)
//                                    .sheet(isPresented: $isPromoSheetVisible, content: {
//                                        PromoCodeView(promo: $promo, isPromoSheetVisible: $isPromoSheetVisible)
//                                            .presentationDetents([.fraction(0.30)])
//                                            .presentationDragIndicator(.visible)
//                                            .onDisappear {
//                                                viewModel.isPromoSheetVisible = true
//                                            }
//                                    })
//                            }
//                        }.padding(.top, 10)
//                    }



//            .fullScreenCover(isPresented: $navigateToCatalog) {
//                TabBar(viewModel: MainTabVM())
//            }

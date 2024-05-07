//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    
    @StateObject private var viewModel = CartVM()
    @StateObject private var catalogVM = CatalogVM()
    @State private var promo: String = ""
    let currentUserId: String
    @State private var isPresented = false
    @State private var orderPlaced = false
    @State private var isPromoSheetVisible = false
    @State private var isPromoCodeEntryPresented = false
    @State private var navigateToCatalog = false
    @State private var isAuthViewPresented = false
    @Binding var currentTab: Int
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 1.8))]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        if viewModel.orderProducts.isEmpty {
                            VStack {
                                if orderPlaced {
                                    VStack {
                                        Text(Localization.thanksForOrder)
                                            .font(.headline)
                                            .foregroundColor(.gray)
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
                            Section(header:
                                        HStack(alignment: .center, spacing: 10) {
                                Text(Localization.products)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.top, 6)
                                    .padding(.leading, 12)
                                Images.Cart.background4
                                    .resizable()
                                    .frame(width: 30, height: 35)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            })
                            {
                                VStack {
                                    ForEach(viewModel.orderProducts) { product in
                                        CartCell(viewModel: viewModel, position: product)
                                            .padding(.bottom, 8)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    Text(Localization.addToOrder)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: layoutForPopular, spacing: 16) {
                            ForEach(catalogVM.popularProducts, id: \.id) { item in
                                PopularProductCell(product: item)
                                    .foregroundColor(.themeText)
                                    .onTapGesture {
                                        viewModel.addPromoProductToOrder(for: item)
                                    }
                            }
                        }.padding(.vertical, 8)
                    }
                    Section {
                        HStack(spacing: 24) {
                            Text(Localization.getDiscount).font(.system(size: 16, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .truncationMode(.tail)
                            Spacer()
                            Button(action: {
                                isPromoSheetVisible.toggle()
                            }) {
                                Text(Localization.promoCode)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: 130, minHeight: 35)
                                    .foregroundColor(.white)
                                    .background(Colors.promo)
                                    .cornerRadius(20)
                                    .shadow(color: Colors.promo.opacity(0.5), radius: 5, x: 0, y: 5)
                                    .sheet(isPresented: $isPromoSheetVisible, content: {
                                        PromoCodeView(promo: $promo, isPromoSheetVisible: $isPromoSheetVisible)
                                            .presentationDetents([.fraction(0.30)])
                                            .presentationDragIndicator(.visible)
                                            .onDisappear {
                                                viewModel.isPromoSheetVisible = true
                                            }
                                    })
                            }
                        }
                    }
                }
                VStack {
                    HStack(spacing: 24) {
                        Text(Localization.total).fontWeight(.bold)
                        Spacer()
                        Text("\(viewModel.productCountMessage) \(Localization.som)").fontWeight(.bold)
                        Button(action: {
                            if viewModel.orderProducts.isEmpty {
                                navigateToCatalog = true
                            } else {
                                if !currentUserId.isEmpty {
                                    viewModel.orderButtonTapped(with: promo)
                                    orderPlaced = true
                                } else {
                                    currentTab = 2
                                }
                            }
                        }) {
                            Text(Localization.order)
                                .font(.body)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: 120)
                                .background(Colors.buy)
                                .cornerRadius(23)
                                .shadow(color: Colors.buy.opacity(0.5), radius: 5, x: 0, y: 5)
                        }
                    }
                    .padding([.leading, .trailing, .bottom], 16)
                }
                .fullScreenCover(isPresented: $navigateToCatalog, onDismiss: nil) {
                    TabBar(viewModel: MainTabViewModel())
                }
            }.navigationBarItems(leading: HStack {
                Text(Localization.cart)
                    .font(.title3.bold())
                    .foregroundColor(.themeText)
                    .padding(.leading, 20)
                    .fixedSize()
                Images.Menu.popular
                    .resizable()
                    .frame(width: 30, height: 35)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 20)
            })
            .onAppear {
                viewModel.fetchOrder()
                Task {
                    await catalogVM.fetchAllProducts()
                }
            }
        }
    }
}


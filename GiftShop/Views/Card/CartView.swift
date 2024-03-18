//  CartView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CartView: View {
    
    @StateObject var viewModel: CartVM
    @StateObject var viewM = CatalogVM()
    @State private var promo: String = ""
    @State private var isPromoCodeEntryPresented = false
    @State private var isPromoSheetVisible = false
    @State private var isPresented: Bool = false
    
    
    @State private var orderPlaced: Bool = false
    
    let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 1.8))]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // MARK: - Order
                    Section {
                        if viewModel.orderProducts.isEmpty {
                            Section {
                                Text(TextMessage.Cart.cardEmpty)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Images.Cart.emptyCart
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 130)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.clear)
                                Text("add_items_to_cart".localized)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Section(header:
                                        HStack(alignment: .center, spacing: 10) {
                                Text("products".localized)
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
                                VStack() {
                                    ForEach(viewModel.orderProducts) { product in
                                        CartCell(viewModel: CartVM.shared, position: product)
                                            .padding(.bottom, 8)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                    }.onAppear {
                        self.viewModel.fetchOrder()
                    }
                    .padding(.bottom, 6)
                    
                    // MARK: - Popular product
                    Section(header: Text("add to order".localized)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.gray)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: layoutForPopular, spacing: 16) {
                                    ForEach(viewM.popularProducts, id: \.id) { item in
                                        PopularProductCell(product: item)
                                            .foregroundColor(.black)
                                            .onTapGesture {
                                                viewModel.addPromoProductToOrder(for: item)
                                            }
                                    }
                                }
                            }.padding(.vertical, 8)
                        }.onAppear {
                            Task {
                                do {
                                    await self.viewM.fetchAllProducts()
                                }
                            }
                        }
                    
                    // MARK: - Promo Section
                    Section {
                        HStack(spacing: 24) {
                            Text("get_discount".localized).font(.system(size: 16, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .truncationMode(.tail)
                            Spacer()
                            Button(action: {
                                isPromoSheetVisible.toggle()
                            }) {
                                Text("promo_code".localized)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: 130, minHeight: 35)
                                    .foregroundColor(.white)
                                    .background(Colors.promo)
                                    .cornerRadius(20)
                                    .shadow(color: Colors.promo.opacity(0.5), radius: 5, x: 0, y: 5)
                                    .sheet(isPresented: $isPromoSheetVisible, content: {
                                        promoCodeView
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
                
                // MARK: - Action Buttons Section
                VStack {
                    HStack(spacing: 24) {
                        Text("total".localized).fontWeight(.bold)
                        Spacer()
                        Text("\(viewModel.productCountMessage) \(NSLocalizedString("com", comment: ""))").fontWeight(.bold)
                        Button(action: {
                            if viewModel.orderProducts.isEmpty {
                                isPresented.toggle()
                            } else {
                                viewModel.orderButtonTapped(with: promo) // Оформляем заказ
                            }
                        }) {
                            Text("order".localized)
                                .font(.body)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: 120)
                                .background(Colors.buy)
                                .cornerRadius(23)
                                .shadow(color: Colors.buy.opacity(0.5), radius: 5, x: 0, y: 5)
                        }.sheet(isPresented: $isPresented) {
                            CatalogView()
                        }
                    }
                    .padding([.leading, .trailing, .bottom], 16)
                }
            }
        }
    }
    
    var promoCodeView: some View {
        ZStack(alignment: .top)  {
            Images.Cart.background6
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 30)
            VStack(spacing: 8) {
                Spacer()
                if viewModel.promoResultText.isEmpty {
                    Text("unlock_exclusive_discount".localized)
                        .customTextStyle(TextStyle.avenirRegular, size: 20)
                        .multilineTextAlignment(.center)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding([.top], 20)
                } else {
                    Text(viewModel.promoResultText)
                        .customTextStyle(TextStyle.avenirRegular, size: 20)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding([.top], 20)
                }
                TextField("enter_promo_code".localized, text: $promo)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                
                HStack(spacing: 16) {
                    Button(action: {
                        isPromoSheetVisible = false
                    }) {
                        Text("cancel".localized)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Colors.promoCancel)
                            .cornerRadius(20)
                            .shadow(color: Colors.promoCancel.opacity(0.5), radius: 5, x: 10, y: 5)
                    }
                    Button(action: {
                        viewModel.promoCode = promo
                        viewModel.applyPromoCode()
                    }) {
                        Text("apply".localized)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Colors.promoApply)
                            .cornerRadius(20)
                            .shadow(color: Colors.promoApply.opacity(0.5), radius: 5, x: 10, y: 5)
                    }
                }
                .padding()
            }
            .padding()
            .cornerRadius(10)
            .shadow(radius: 4)
        }.onAppear {
            viewModel.promoCode = ""
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: CartVM.shared )
    }
}


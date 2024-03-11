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
                            Text("Корзина пока пуста")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Image("emptyCartImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 130)
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                            Text("Добавьте товары в корзину, чтобы начать покупки!")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        else {
                            Section(header:
                                        HStack(alignment: .center, spacing: 10) {
                                Text("Товары")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(.top, 6)
                                    .padding(.leading, 12)
                                Image("background4")
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
                    Section(header: Text("Добавить к заказу?")
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
                            Text("Получить скидку!").font(.system(size: 16, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .truncationMode(.tail)
                            Spacer()
                            Button(action: {
                                isPromoSheetVisible.toggle()
                            }) {
                                Text("Промокод")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: 130, minHeight: 35)
                                    .foregroundColor(.white)
                                    .background(Color("promoButton"))
                                    .cornerRadius(20)
                                    .shadow(color: Color("promoButton").opacity(0.5), radius: 5, x: 0, y: 5)
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
                        Text("Итого").fontWeight(.bold)
                        Spacer()
                        Text("\(viewModel.productCountMessage) сом").fontWeight(.bold)
                        Button(action: {
                            print("Заказать")
                            if viewModel.orderProducts.isEmpty {
                                isPresented.toggle()
                            } else {
                                viewModel.orderButtonTapped(with: promo) // Оформляем заказ
                            }
                        }) {
                            Text("Заказать")
                                .font(.body)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                                .frame(maxWidth: 120)
                                .background(Color("buyButton"))
                                .cornerRadius(23)
                                .shadow(color: Color("buyButton").opacity(0.5), radius: 5, x: 0, y: 5)
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
            Image("background6")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 30)
            VStack(spacing: 8) {
                Spacer()
                if viewModel.promoResultText.isEmpty {
                    Text("Разблокируйте эксклюзивную скидку!")
                        .font(.custom("AvenirNext-regular", size: 20))
                        .multilineTextAlignment(.center)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding([.top], 20)
                } else {
                    Text(viewModel.promoResultText)
                        .font(.custom("AvenirNext-regular", size: 20))
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding([.top], 20)
                }
                TextField("Введите промокод", text: $promo)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                
                HStack(spacing: 16) {
                    Button(action: {
                        isPromoSheetVisible = false
                    }) {
                        Text("Отмена")
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color("promoCancel"))
                            .cornerRadius(20)
                            .shadow(color: Color("promoCancel").opacity(0.5), radius: 5, x: 10, y: 5)
                    }
                    
                    Button(action: {
                        viewModel.promoCode = promo
                        viewModel.applyPromoCode()
                    }) {
                        Text("Применить")
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color("promoApply"))
                            .cornerRadius(20)
                            .shadow(color: Color("promoApply").opacity(0.5), radius: 5, x: 10, y: 5)
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


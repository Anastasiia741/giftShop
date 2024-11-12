//  CatalogView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CatalogView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = CatalogVM()
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 2.2))]
    private let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(1.5)
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        Section {
                            HStack(alignment: .center, spacing: 10) {
                                Text(Localization.popular)
                                    .font(.title3.bold())
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                    .padding(.leading, 20)
                                Image(uiImage: UIImage(named: colorScheme == .dark ? Images.Menu.popular2 : Images.Menu.popular1) ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 50)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHGrid(rows: layoutForPopular, spacing: 6) {
                                    ForEach(viewModel.popularProducts) { item in
                                        NavigationLink {
                                            let viewModel = ProductDetailVM(product: item)
                                            ProductDetailView(viewModel: viewModel)
                                        } label: {
                                            PopularProductCell(product: item)
                                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                        }
                                    }
                                }.padding()
                            }
                        }
                        
                       
                        Section {
                            HStack(alignment: .center, spacing: 10) {
                                Text(Localization.products)
                                    .font(.title3.bold())
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                                Image(uiImage: UIImage(named: colorScheme == .dark ? Images.Menu.popular2 : Images.Menu.popular1) ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 50)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.horizontal, 20)
                            
                            
                            Section {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    
                                    HStack {
                                        ForEach(viewModel.categories, id: \.self) { category in
                                            Button(action: {
                                                viewModel.selectedCategory = category
                                                viewModel.filterProducts(by: category)
                                            }) {
                                                Text(category)
                                                    .fontWeight(.bold)
                                                    .padding(.vertical, 8)
                                                    .padding(.horizontal, 16)
                                                    .foregroundColor(.white)
                                                    .background(viewModel.selectedCategory == category ? Colors.yellow : Colors.whiteAlfa)
                                                    .cornerRadius(20)
                                                    .shadow(color: Colors.promo.opacity(0.5), radius: 5, x: 0, y: 5)
                                            }
                                        }
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                }
                            }
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: layoutForProducts) {
                                    ForEach(viewModel.filteredProducts) { item in
                                        NavigationLink {
                                            let viewModel = ProductDetailVM(product: item)
                                            ProductDetailView(viewModel: viewModel)
                                        } label: {
                                            ProductCell(product: item)
                                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                        }
                                    }
                                }.padding()
                            }
                        }
                    }
                }
            }
            .task {
                isLoading = true
                await self.viewModel.fetchAllProducts()
                isLoading = false
            }
        }
    }
}

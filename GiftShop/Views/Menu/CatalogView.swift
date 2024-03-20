//  CatalogView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct CatalogView: View {
    
    @StateObject var viewModel = CatalogVM()
    let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 2.2))]
    let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                Section {
                    HStack(alignment: .center, spacing: 10) {
                        Text(Localization.popular)
                            .font(.title3.bold())
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                        Images.Menu.popular
                            .resizable()
                            .frame(width: 30, height: 35)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: layoutForPopular, spacing: 16) {
                            ForEach(viewModel.popularProducts, id: \.id) { item in
                                NavigationLink {
                                    let viewModel = ProductDetailVM(product: item)
                                    ProductDetailView(viewModel: viewModel)
                                } label: {
                                    ProductCell(product: item)
                                        .foregroundColor(.black)
                                }
                            }
                        }.padding()
                    }
                }
                Section {
                    HStack(alignment: .center, spacing: 10) {
                        Text(Localization.products)
                            .font(.title3.bold())
                            .foregroundColor(.black)
                        Images.Menu.popular
                            .resizable()
                            .frame(width: 30, height: 35)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.horizontal, 20)
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: layoutForProducts) {
                            ForEach(viewModel.allProducts, id: \.id) { item in
                                NavigationLink {
                                    let viewModel = ProductDetailVM(product: item)
                                    ProductDetailView(viewModel: viewModel)
                                } label: {
                                    ProductCell(product: item)
                                        .foregroundColor(.black)
                                }
                            }
                        }.padding()
                    }
                }.onAppear {
                    Task {
                        await self.viewModel.fetchAllProducts()
                    }
                }
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}

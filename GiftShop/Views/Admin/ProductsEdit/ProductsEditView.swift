//  ProductEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct ProductsEditView: View {
    
    @StateObject var catalogVM: CatalogVM
    let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 2.2))]
    let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                Section {
                    HStack(alignment: .center, spacing: 10) {
                        Text(TextMessage.Menu.porular)
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
                            ForEach(catalogVM.popularProducts, id: \.id) { item in
                                NavigationLink {
                                    let viewModel = ProductDetailEditVM(selectedProduct: item)
                                    ProductDetailEditView(viewModel: viewModel)
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
                        Text(TextMessage.Menu.porular)
                            .font(.title3.bold())
                            .foregroundColor(.black)
                        Images.Menu.popular
                            .resizable()
                            .frame(width: 30, height: 35)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.horizontal, 20)
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: layoutForProducts) {
                            ForEach(catalogVM.allProducts, id: \.id) { item in
                                NavigationLink {
                                    let viewModel = ProductDetailEditVM(selectedProduct: item)
                                    ProductDetailEditView(viewModel: viewModel)
                                } label: {
                                    ProductCell(product: item)
                                        .foregroundColor(.black)
                                }
                            }
                        }.padding()
                    }
                }.onAppear {
                    Task {
                        await self.catalogVM.fetchAllProducts()
                    }
                }
            }
        }
    }
}

struct ProductEditView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}

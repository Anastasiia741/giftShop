//  ProductEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct ProductsEditView: View {
    
    @StateObject var catalogVM: CatalogVM
    private let layoutForPopular = [GridItem(.adaptive(minimum: screen.width / 2.2))]
    private let layoutForProducts = [GridItem(.adaptive(minimum: screen.width / 2.4))]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                Section {
                    HStack(alignment: .center, spacing: 10) {
                        Text(Localization.popular)
                            .font(.title3.bold())
                            .foregroundColor(.themeText)
                            .padding(.leading, 20)
                        Image(uiImage: UIImage(named: colorScheme == .dark ? Images.Menu.popular2 : Images.Menu.popular2) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 50)
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
                                        .foregroundColor(.themeText)
                                }
                            }
                        }.padding()
                    }
                }
                Section {
                    HStack(alignment: .center, spacing: 10) {
                        Text(Localization.products)
                            .font(.title3.bold())
                            .foregroundColor(.themeText)
                        Image(uiImage: UIImage(named: colorScheme == .dark ? Images.Menu.popular2 : Images.Menu.popular2) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 50)
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
                                        .foregroundColor(.themeText)
                                }
                            }
                        }.padding()
                    }
                }.onAppear {
                    Task {
                        await catalogVM.fetchAllProducts()
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

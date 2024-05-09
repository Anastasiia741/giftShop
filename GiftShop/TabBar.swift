//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    
    @StateObject var viewModel: MainTabViewModel
    @State private var curentTab: Int = 0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView(selection: $curentTab) {
            if let userID = viewModel.userID {
                if userID == Accesses.adminUser {
                    OrdersView()
                        .tabItem {
                            VStack {
                                Images.TabBar.order
                            }
                        }
                        .tag(TabType.orders.rawValue)
                    ProductsEditView(catalogVM: CatalogVM())
                        .tabItem {
                            VStack {
                                Images.TabBar.productEdit
                            }
                        }
                        .tag(TabType.productsEdit.rawValue)
                    CreateProductView()
                        .tabItem {
                            VStack {
                                Images.TabBar.createProduct
                            }
                        }
                        .tag(TabType.createProduct.rawValue)
                } else {
                    CatalogView()
                        .tabItem {
                            VStack {
                                Images.TabBar.menu
                            }
                        }
                        .tag(TabType.catalog.rawValue)
                    CartView(currentUserId: userID, currentTab: $curentTab)
                        .tabItem {
                            VStack {
                                Images.TabBar.cart
                            }
                        }
                        .tag(TabType.cart.rawValue)
                    ProfileView()
                        .tabItem {
                            VStack {
                                Images.TabBar.profile
                            }
                        }
                        .tag(TabType.profile.rawValue)
                }
            } else {
                CatalogView()
                    .tabItem {
                        VStack {
                            Images.TabBar.menu
                        }
                    }
                    .tag(TabType.catalog.rawValue)
                CartView(currentUserId: "", currentTab: $curentTab)
                    .tabItem {
                        VStack {
                            Images.TabBar.cart
                        }
                    }
                    .tag(TabType.cart.rawValue)
                AuthView()
                    .tabItem {
                        VStack {
                            Images.TabBar.profile
                        }
                    }
                    .tag(TabType.profile.rawValue)
            }
        }
        .accentColor(colorScheme == .dark ? Color.white : Color.black)
        .onAppear {
            viewModel.fetchUserId()
        }
    }
}


//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: MainTabVM
    @State private var curentTab: Int = 0
    
    var body: some View {
        TabView(selection: $curentTab) {
            if let userID = viewModel.userID {
                if userID == Accesses.adminUser || userID == Accesses.adminKiyiz {
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
                    CartView(currentTab: $curentTab, currentUserId: userID)
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
                CartView(currentTab: $curentTab, currentUserId: "")
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


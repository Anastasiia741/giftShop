//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    
    @StateObject var viewModel: MainTabViewModel
    @State private var tabColor: Color = .themeText
    @State private var curentTab: Int = 0
    
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
                        .tag(TabType.orders)
                    ProductsEditView(catalogVM: CatalogVM())
                        .tabItem {
                            VStack {
                                Images.TabBar.productEdit
                            }
                        }
                        .tag(TabType.productsEdit)
                    CreateProductView()
                        .tabItem {
                            VStack {
                                Images.TabBar.createProduct
                            }
                        }
                        .tag(TabType.createProduct)
                } else {
                    CatalogView()
                        .tabItem {
                            VStack {
                                Images.TabBar.menu
                            }
                        }
                        .tag(TabType.catalog)
                    CartView(currentUserId: userID, currentTab: $curentTab)
                        .tabItem {
                            VStack {
                                Images.TabBar.cart
                            }
                        }
                        .tag(TabType.cart)
                    ProfileView()
                        .tabItem {
                            VStack {
                                Images.TabBar.profile
                            }
                        }
                        .tag(TabType.profile)
                }
            } else {
                CatalogView()
                    .tabItem {
                        VStack {
                            Images.TabBar.menu
                        }
                    }
                    .tag(TabType.catalog)
                CartView(currentUserId: "", currentTab: $curentTab)
                    .tabItem {
                        VStack {
                            Images.TabBar.cart
                        }
                    }
                    .tag(TabType.cart)
                AuthView()
                    .tabItem {
                        VStack {
                            Images.TabBar.profile
                        }
                    }
                    .tag(TabType.profile)
            }
        }
        .accentColor(tabColor)
        .onAppear {
            viewModel.fetchUserId()
        }
    }
}


//enum TabType: Int {
//    case home, theory, tasks, favorite, profile
//}

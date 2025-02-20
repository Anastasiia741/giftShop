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
                                Text("Заказы")
                            }
                        }
                        .tag(TabType.orders.rawValue)
                    CustomOrdersAdminView()
                        .tabItem {
                            VStack {
                                Images.TabBar.customOrder
                                Text("Личные")
                            }
                        }
                        .tag(TabType.customOrders.rawValue)
                    ProductsEditView(catalogVM: CatalogVM())
                        .tabItem {
                            VStack {
                                Images.TabBar.productEdit
                                Text("Товары")
                            }
                        }
                        .tag(TabType.productsEdit.rawValue)
                    CreateProductView()
                        .tabItem {
                            VStack {
                                Images.TabBar.createProduct
                                Text("Создать")
                            }
                        }
                        .tag(TabType.createProduct.rawValue)
                } else {
                    
                    CatalogView(currentTab: $curentTab)
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
                CatalogView(currentTab: $curentTab)
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
                AuthenticationView()
                    .tabItem {
                        VStack {
                            Images.TabBar.profile
                        }
                    }
                    .tag(TabType.profile.rawValue)
            }
        }
        .toolbarBackground(Color.white, for: .tabBar)
        
        .navigationBarBackButtonHidden(true)
        .accentColor(colorScheme == .dark ? Color.white : Color.black)
        .onAppear {
            viewModel.fetchUserId()
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor =  colorScheme == .dark ? .black : .white
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}



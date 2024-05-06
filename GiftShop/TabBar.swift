//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    
    @StateObject var viewModel: MainTabViewModel
    @State private var tabColor: Color = .black
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
                        .tag(0)
                    ProductsEditView(catalogVM: CatalogVM())
                        .tabItem {
                            VStack {
                                Images.TabBar.productEdit
                            }
                        }
                        .tag(1)
                    CreateProductView()
                        .tabItem {
                            VStack {
                                Images.TabBar.createProduct
                            }
                        }
                        .tag(2)
                } else {
                    CatalogView()
                        .tabItem {
                            VStack {
                                Images.TabBar.menu
                            }
                        }
                        .tag(0)
                    CartView(currentTab: $curentTab, currentUserId: userID)
                        .tabItem {
                            VStack {
                                Images.TabBar.cart
                            }
                        }
                        .tag(1)
                    ProfileView()
                        .tabItem {
                            VStack {
                                Images.TabBar.profile
                            }
                        }
                        .tag(2)
                }
            } else {
                CatalogView()
                    .tabItem {
                        VStack {
                            Images.TabBar.menu
                        }
                    }
                    .tag(0)
                CartView(currentTab: $curentTab, currentUserId: "")
                    .tabItem {
                        VStack {
                            Images.TabBar.cart
                        }
                    }
                    .tag(1)
                AuthView()
                    .tabItem {
                        VStack {
                            Images.TabBar.profile
                        }
                    }
                    .tag(2)
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

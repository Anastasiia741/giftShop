//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    
    @StateObject var viewModel: MainTabViewModel
    @State private var tabColor: Color = .black
    
    var body: some View {
        TabView {
            if let userID = viewModel.userID {
                if userID == Accesses.adminUser {
                    OrdersView()
                        .tabItem {
                            VStack {
                                Images.TabBar.order
                            }
                        }
                    ProductsEditView(catalogVM: CatalogVM.shared)
                        .tabItem {
                            VStack {
                                Images.TabBar.productEdit
                            }
                        }
                    CreateProductView()
                        .tabItem {
                            VStack {
                                Images.TabBar.createProduct
                            }
                        }
                } else {
                    CatalogView()
                        .tabItem {
                            VStack {
                                Images.TabBar.menu
                            }
                        }
                    CartView()
                        .tabItem {
                            VStack {
                                Images.TabBar.cart
                            }
                        }
                    ProfileView()
                        .tabItem {
                            VStack {
                                Images.TabBar.profile
                            }
                        }
                }
            } else {
                CatalogView()
                    .tabItem {
                        VStack {
                            Images.TabBar.menu
                        }
                    }
                CartView()
                    .tabItem {
                        VStack {
                            Images.TabBar.cart
                        }
                    }
                AuthView()
                    .tabItem {
                        VStack {
                            Images.TabBar.profile
                        }
                    }
            }
        }
        .accentColor(tabColor)
        .onAppear {
            viewModel.fetchUserId()
        }
    }
}




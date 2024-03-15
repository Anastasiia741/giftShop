//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    
    @StateObject var viewModel: MainTabViewModel
    @State private var tabColor: Color = .black
    
    var body: some View {
        TabView {
            if AuthService.shared.currentUser != nil {
                if AuthService.shared.currentUser?.uid == Accesses.currentUser {
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
                    CartView(viewModel: CartVM.shared)
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
            } else if AuthService.shared.currentUser == nil {
                CatalogView()
                    .tabItem {
                        VStack {
                            Images.TabBar.menu
                        }
                    }
                CartView(viewModel: CartVM.shared)
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
    }
}




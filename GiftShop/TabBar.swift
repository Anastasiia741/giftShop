//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI

struct TabBar: View {
    
    @StateObject var viewModel: MainTabViewModel
    @State private var tabColor: Color = .black
    private let authService = AuthService()
    
    var body: some View {
        
        TabView {
            if authService.currentUser != nil {
                if authService.currentUser?.uid == "OKYK7MdkwCTxWh5jl6MvbLk48B02" {
                    OrdersView()
                        .tabItem {
                            VStack {
                                Image(systemName: "list.bullet")
                            }
                        }
                    ProductsEditView(catalogVM: CatalogVM.shared)
                        .tabItem {
                            VStack {
                                Image(systemName: "square.and.pencil")
                            }
                        }
                    CreateProductView()
                        .tabItem {
                            VStack {
                                Image(systemName: "plus.circle")
                            }
                        }
                } else {
                    CatalogView()
                        .tabItem {
                            VStack {
                                Image(systemName: "menucard")
                            }
                        }
                    CartView(viewModel: CartVM.shared)
                        .tabItem {
                            VStack {
                                Image(systemName: "cart")
                            }
                        }
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person.circle")
                            }
                        }
                }
            } else if authService.currentUser == nil {
                CatalogView()
                    .tabItem {
                        VStack {
                            Image(systemName: "menucard")
                        }
                    }
                CartView(viewModel: CartVM.shared)
                    .tabItem {
                        VStack {
                            Image(systemName: "cart")
                        }
                    }
                AuthView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.circle")
                        }
                    }
            }
        }
        .accentColor(tabColor)
    }
}




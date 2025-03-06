//  TabBar.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI


struct TabBar: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: MainTabVM
    @State private var currentTab: Int = 0
    
    var body: some View {
        Group {
            if let userID = viewModel.userID {
                if userID == Accesses.adminUser || userID == Accesses.adminKiyiz {
                    AdminTabView(currentTab: $currentTab)
                    
                } else {
                    UserTabView(currentTab: $currentTab, userID: userID)
                    
                }
            } else {
                GuestTabView(currentTab: $currentTab)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchUserId()
            setupTabBarAppearance()
        }
    }
}

extension TabBar {
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = (colorScheme == .dark ? UIColor.black : UIColor.white)
        
        let activeTabColor = colorScheme == .dark ? UIColor.colorLightBrown : UIColor.colorDarkBrown
        let inactiveTabColor = UIColor.gray
        
        appearance.stackedLayoutAppearance.selected.iconColor = activeTabColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: activeTabColor]
        
        appearance.stackedLayoutAppearance.normal.iconColor = inactiveTabColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: inactiveTabColor]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct AdminTabView: View {
    @Binding var currentTab: Int
    
    var body: some View {
        TabView(selection: $currentTab) {
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
        }
    }
}


struct UserTabView: View {
    @Binding var currentTab: Int
    let userID: String
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $currentTab) {
            CatalogView(navigationPath: $navigationPath, currentTab: $currentTab)
                .tabItem {
                    VStack {
                        Images.TabBar.menu
                    }
                }
                .tag(TabType.catalog.rawValue)
            
            CartView(currentUserId: userID, currentTab: $currentTab, navigationPath: $navigationPath)
                .tabItem {
                    VStack {
                        Images.TabBar.cart
                    }
                }
                .tag(TabType.cart.rawValue)
            
            ProfileView(currentTab: $currentTab)
                .tabItem {
                    VStack {
                        Images.TabBar.profile
                    }
                }
                .tag(TabType.profile.rawValue)
        }
    }
}

struct GuestTabView: View {
    @Binding var currentTab: Int
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $currentTab) {
            CatalogView(navigationPath: $navigationPath, currentTab: $currentTab)
                .tabItem {
                    VStack {
                        Images.TabBar.menu
                    }
                }
                .tag(TabType.catalog.rawValue)
            
            CartView(currentUserId: "", currentTab: $currentTab, navigationPath: $navigationPath)
                .tabItem {
                    VStack {
                        Images.TabBar.cart
                    }
                }
                .tag(TabType.cart.rawValue)
            
            AuthenticationView(currentTab: $currentTab)
                .tabItem {
                    VStack {
                        Images.TabBar.profile
                    }
                }
                .tag(TabType.profile.rawValue)
        }
        .navigationBarBackButtonHidden(true)
        
        
    }
}




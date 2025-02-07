//  AdminView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

//struct OrdersView: View {
//    @Environment(\.colorScheme) private var colorScheme
//    @StateObject var viewModel = OrdersVM()
//    @State private var selectedStatus: OrderStatus = .all
//    @State private var isAlertPresenter = false
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(OrderStatus.allCases, id: \.self) { status in
//                            Button(action: {
//                                selectedStatus = status
//                                viewModel.filterOrdersByStatus(status)
//                            }) {
//                                Text(status.rawValue)
//                                    .font(.callout)
//                                    .fontWeight(.medium)
//                                    .frame(maxWidth: .infinity)
//                                    .frame(height: 35)
//                                    .padding(.horizontal, 20)
//                                    .foregroundColor(selectedStatus == status ? (colorScheme == .light ? Color.white : Color.black) : .black)                                     
//                                    .background(selectedStatus == status ? (colorScheme == .dark ? Color.white : Color.black) : Color.gray)
//                                    .cornerRadius(20)
//                                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 5)
//                            }
//                        }
//                        .padding(.bottom, 10)
//                    }
//                }
//                .padding()
//                List(viewModel.filteredOrders) { order in
//                    OrderCell(order: .constant(order))
//                }
//            }
//            .navigationBarItems(trailing: Button(action: {
//                isAlertPresenter = true
//            }) {
//                Images.Profile.exit
//                    .imageScale(.small)
//                    .foregroundColor(colorScheme == .dark ? .white : .black)
//            })
//            .actionSheet(isPresented: $isAlertPresenter) {
//                ActionSheet(
//                    title: Text(Localization.logOut),
//                    buttons: [
//                        .default(Text(Localization.yes)) {
//                            viewModel.logout()
//                        },
//                        .cancel(Text(Localization.cancel))
//                    ]
//                )
//            }
//            .fullScreenCover(isPresented: $viewModel.showQuitPresenter) {
//                NavigationView {
//                    TabBar(viewModel: MainTabVM())
//                }
//            }
//            .onAppear {
//                viewModel.fetchUserOrders()
//            }
//        }
//    }
//}
//

struct OrdersView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel = OrdersVM()
    @State private var selectedStatus: OrderStatus = .all
    @State private var isAlertPresenter = false
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "Заказы")
                    .padding(.top, 4)
                statusFilterBar
                ordersList
            }
            .navigationBarItems(trailing: logoutButton)
            .actionSheet(isPresented: $isAlertPresenter, content: logoutActionSheet)
            .fullScreenCover(isPresented: $viewModel.showQuitPresenter) {
                NavigationView {
                    TabBar(viewModel: MainTabVM())
                }
            }
            .onAppear {
                viewModel.fetchUserOrders()
            }
        }
    }
    
    // MARK: - Status Filter Bar
    private var statusFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    StatusButton(
                        text: status.rawValue,
                        isSelected: selectedStatus == status
                    ) {
                        selectedStatus = status
                        viewModel.filterOrders(status)
                    }
                }
            }
            .padding(.bottom, 10)
        }
        .padding()
    }

    // MARK: - Orders List
    private var ordersList: some View {
        List(viewModel.filteredOrders) { order in
            OrderCell(order: .constant(order))
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
        .scrollContentBackground(.hidden)
        .padding(.vertical)
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            isAlertPresenter = true
        }) {
            Images.Profile.exit
                .imageScale(.small)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }
    
    // MARK: - Logout Action Sheet
    private func logoutActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text(Localization.logOut),
            buttons: [
                .default(Text(Localization.yes)) {
                    viewModel.logout()
                },
                .cancel(Text(Localization.cancel))
            ]
        )
    }
}

//  AdminView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct OrdersView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel = OrdersVM()
    @State private var selectedStatus: OrderStatus = .all
    @State private var isShowExit = false
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "Заказы")
                statusSection
                orders
            }
            .navigationBarItems(trailing: LogoutButton(viewModel: viewModel, colorScheme: colorScheme, isPresented: $isShowExit))
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
}
    
extension OrdersView {
    private var statusSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(OrderStatus.allCases, id: \.self) { status in
                    DetailButton(text: status.rawValue, isSelected: selectedStatus == status) {
                        selectedStatus = status
                        viewModel.filterOrders(status)
                    }
                }
            }
            .padding(.bottom, 10)
        }
        .padding()
    }
    
    private var orders: some View {
        List(viewModel.filteredOrders) { order in
            OrderCell(order: .constant(order))
        }
        .listStyle(PlainListStyle())
        .background(Color.clear)
        .scrollContentBackground(.hidden)
        .padding(.vertical)
    }
}


struct LogoutButton: View {
    @ObservedObject var viewModel: OrdersVM
    let colorScheme: ColorScheme
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: { isPresented = true }) {
            Images.Profile.exit
                .imageScale(.small)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .actionSheet(isPresented: $isPresented) {
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
}

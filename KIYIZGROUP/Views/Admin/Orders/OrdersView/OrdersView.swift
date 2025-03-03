//  AdminView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct OrdersView: View {
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
            .navigationBarItems(trailing: LogoutButton(viewModel: viewModel, isPresented: $isShowExit))
            .fullScreenCover(isPresented: $viewModel.showQuit) {
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



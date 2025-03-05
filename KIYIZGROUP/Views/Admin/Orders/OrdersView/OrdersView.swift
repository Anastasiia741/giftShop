//  AdminView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var mainTabVM: MainTabVM
    @StateObject var viewModel = OrdersVM()
    @State private var selectedStatus: OrderStatus = .all
    @State private var showQuit = false
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "Заказы")
                    .padding(.top, 4)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            DetailButton(text: status.rawValue, isSelected: selectedStatus == status
                            ) {
                                selectedStatus = status
                                viewModel.filterOrders(status)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                List(viewModel.filteredOrders) { order in
                    OrderCell(order: .constant(order))
                }
                
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                .padding(.vertical)
            }
            .navigationBarItems(trailing: LogoutButton(viewModel: viewModel, isPresented: $showQuit))
        }
        .navigationDestination(isPresented: $viewModel.showQuit) {
//            NavigationView{
                TabBar(viewModel: mainTabVM)
//            }
        }
        .onAppear {
            Task{
                viewModel.fetchUserOrders()
                await viewModel.fetchUserProfile()
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
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.filteredOrders) { order in
                    OrderCell(order: .constant(order))
                    
                }
            }
            .padding()
        }
    }
    
    
    //    private var orders: some View {
    //        List(viewModel.filteredOrders) { order in
    //            OrderCell(order: .constant(order))
    //        }
    //        .listStyle(PlainListStyle())
    //        .background(Color.clear)
    //        .scrollContentBackground(.hidden)
    //        .padding(.vertical)
    //    }
}



//  CustomOrdersAdminView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 7/2/25.

import SwiftUI

struct CustomOrdersAdminView: View {
    @EnvironmentObject var mainTabVM: MainTabVM
    @StateObject var viewModel = OrdersVM()
    @State private var selectedStatus: OrderStatus = .all
    private let textComponent = TextComponent()
    @State private var isShowExit = false
    
    var body: some View {
        NavigationView {
            VStack {
                CustomHeaderView(title: "Индивидуальные заказы")
                    .padding(.top, 4)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            DetailButton(text: status.rawValue, isSelected: selectedStatus == status
                            ) {
                                selectedStatus = status
                                viewModel.filterCustomOrders(status)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                List(viewModel.filteredCustomOrders) { order in
                    CustomOrderCell(order: .constant(order))
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                .padding(.vertical)
            }
            .navigationBarItems(trailing: LogoutButton(viewModel: viewModel, isPresented: $isShowExit))
            .navigationDestination(isPresented: $viewModel.showQuit) {
                TabBar(viewModel: mainTabVM)
            }
            .onAppear {
                viewModel.fetchCustomOrders()
            }
        }
    }
}


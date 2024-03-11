//  AdminView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct OrdersView: View {
    
    @StateObject var viewModel = OrdersVM()
    @State private var isQuitAlertPresenter = false
    @State private var isAuthViewPresenter = false
    @State private var selectedStatus: OrderStatus = .all
    
    var body: some View {
        NavigationView {
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            Button(action: {
                                selectedStatus = status
                                viewModel.filterOrdersByStatus(status)
                            }) {
                                Text(status.rawValue)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 35)
                                    .padding(.horizontal, 20)
                                    .foregroundColor(selectedStatus == status ? .white : .black)
                                    .background(selectedStatus == status ? Color.black : Color.gray)
                                    .cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 10, y: 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding()
                List(viewModel.filteredOrders) { order in
                    OrderCell(order: order)
                    
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                isQuitAlertPresenter = true
            }) {
                Image(systemName: "arrowshape.turn.up.right")
            })
            .confirmationDialog("Хотите выйти?", isPresented: $isQuitAlertPresenter) {
                Button {
                    isAuthViewPresenter.toggle()
                    Task {
                      await viewModel.logout()
                    }
                } label: {
                    Text("Выйти")
                }
                Button(role: .cancel) {
                    print("Отмена")
                } label: {
                    Text("Отмена")
                }
            }
            .fullScreenCover(isPresented: $isAuthViewPresenter, onDismiss: nil) {
                AuthView()
            }
            .onAppear {
                viewModel.fetchUserOrders()
            }
        }
    }
}



#Preview {
    OrdersView()
}

//  File.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation

final class OrdersVM: ObservableObject {
    private let dbOrdersService = DBOrdersService()
    private let productService = CustomProductService()
    private let authService = AuthService()
    
    private var selectOrder: Order?
    private var selectedStatus: OrderStatus = .all
    @Published var orders: [Order] = []
    @Published var filteredOrders: [Order] = []
    @Published var customOrders: [CustomOrder] = []
    @Published var filteredCustomOrders: [CustomOrder] = []
    @Published var showQuitPresenter = false
}


extension OrdersVM {
    func fetchUserOrders() {
        dbOrdersService.fetchUserOrders { [weak self] orders  in
            let sortedOrders = orders.sorted(by: { $0.date > $1.date })
            self?.orders = sortedOrders
            self?.filterOrders(.all)
        }
    }
    
    func fetchCustomOrders() {
        Task {
            do {
                let orders = try await productService.fetchCustomOrders()
                let sortedOrders = orders.sorted { $0.date > $1.date }
                await MainActor.run {
                    self.customOrders = sortedOrders
                    self.filteredCustomOrders = sortedOrders
                }
            } catch {
                print("Error fetching orders: \(error.localizedDescription)")
            }
        }
    }
}

extension OrdersVM {
    func filterOrders(_ status: OrderStatus) {
        selectedStatus = status
        switch status {
        case .all:
            filteredOrders = orders
        default:
            filteredOrders = orders.filter { $0.status == status.rawValue }
        }
    }
    
    
    func filterCustomOrders(_ status: OrderStatus) {
        if status == .all {
            filteredCustomOrders = customOrders
        } else {
            filteredCustomOrders = customOrders.filter { $0.status == status.rawValue }
        }
    }
}

extension OrdersVM {
    func logout()  {
        authService.signOut{ result in
            switch result {
            case .success:
                self.showQuitPresenter = true
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}



//  File.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation

final class OrdersVM: ObservableObject {
    
    private var databaseService = DBOrdersService()
    private let authService = AuthService()

    @Published var filteredOrders: [Order] = []
    @Published var orders: [Order] = []
    var selectOrder: Order?
    private var selectedStatus: OrderStatus = .all
    
    func fetchUserOrders() {
        databaseService.fetchUserOrders { [weak self] orders  in
            let sortedOrders = orders.sorted(by: { $0.date > $1.date })
            self?.orders = sortedOrders
            self?.filterOrdersByStatus(.all)
        }
    }
    
    func filterOrdersByStatus(_ status: OrderStatus) {
        selectedStatus = status
        switch status {
        case .all:
            filteredOrders = orders
            print("---->", filteredOrders)
        default:
            filteredOrders = orders.filter { $0.status == status.rawValue }
        }
       
    }
    
    func logout()  {
        authService.signOut{ result in
            switch result {
            case .success:
                print("Аккаунт успешно удален")
            case .failure(let error):
                print("Ошибка удаления аккаунта: \(error.localizedDescription)")
            }
        }
    }
    
}


//  OrderDetailVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation

final class OrderDetailVM: ObservableObject {
    
    private let profileService = ProfileService()
    private let dbOrderService = DBOrdersService()
    private let orderService = OrderService()
    @Published var selectedOrder: Order?
    @Published var userProfile: NewUser?
    
    func fetchUserProfile() async {
        guard let userID = selectedOrder?.userID else { return }
        do {
            let userProfile = try await profileService.getProfile(by: userID)
            DispatchQueue.main.async {
                self.userProfile = userProfile
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateOrderStatus(orderID: String, newStatus: String) {
        dbOrderService.updateOrderStatus(orderID: orderID, newStatus: newStatus) { [weak self] in
            self?.selectedOrder?.status = newStatus
            self?.objectWillChange.send()
        }
    }
}

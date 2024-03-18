//  OrderDetailVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation

final class OrderDetailVM: ObservableObject {
   
    private let profileService = ProfileService()
    private let orderService = OrderService()
    @Published var selectedOrder: Order?
    @Published var userProfile: NewUser?
    static let shared = OrderDetailVM()
    
    func fetchUserProfile() async {
        guard let userID = selectedOrder?.userID else { return }
        do {
            let userProfile = try await profileService.getProfile(by: userID)
            DispatchQueue.main.async {
                self.userProfile = userProfile
            }
        } catch {
            print("Error fetching user profile: \(error.localizedDescription)")
        }
    }
    
    func fetchOrderDetails() {
        if let order = selectedOrder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy \nВремя - HH:mm"
            _ = dateFormatter.string(from: order.date)
            _ = formatOrderItemsText(for: order)
        }
    }
    
    func formatOrderItemsText(for order: Order) -> String {
        var itemsText = ""
        for position in order.positions {
            let itemText = "\(position.product.name): \(position.count) \(NSLocalizedString("amount", comment: ""))."
            if itemsText.isEmpty {
                itemsText = itemText
            } else {
                itemsText += "\n\(itemText)"
            }
        }
        return itemsText
    }
}

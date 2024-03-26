//  OrderDetailVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation

final class OrderDetailVM: ObservableObject {
    
    private let profileService = ProfileService()
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
            print("Ошибка при получении профиля пользователя: \(error.localizedDescription)")
        }
    }
    
    func formatOrderItemsText(for order: Order) -> String {
        var itemsText = ""
        for position in order.positions {
            let itemText = "\(position.product.name): \(position.count) \(Localization.amount)."
            if itemsText.isEmpty {
                itemsText = itemText
            } else {
                itemsText += "\n\(itemText)"
            }
        }
        return itemsText
    }
}

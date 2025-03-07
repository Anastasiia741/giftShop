//  File.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation
import UIKit
import SwiftUICore
import FirebaseStorage

@MainActor
final class OrdersVM: ObservableObject {
    private let dbOrdersService = DBOrdersService()
    private let profileService = ProfileService()
    private let orderService = OrderService()
    private let productService = CustomProductService()
    private let authService = AuthService()
    private let dbOrderService = DBOrdersService()
    
    var selectOrder: Order?
    @Published var userProfile: NewUser?
    @Published var selectedStatus: OrderStatus = .all
    @Published var orders: [Order] = []
    @Published var filteredOrders: [Order] = []
    @Published var customOrders: [CustomOrder] = []
    @Published var filteredCustomOrders: [CustomOrder] = []
    
    @Published var designImage: [String: URL] = [:]
    @Published var attachedImage: [String: URL] = [:]
    
    @Published var showQuit = false
    @Published var imageURL: URL?
}


//MARK: - Orders
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
                    for order in sortedOrders {
                        self.fetchImages(order: order)
                    }
                }
            }
        }
    }
    
    func fetchUserProfile() async {
        guard let userID = selectOrder?.userID else {
            
            return }
        do {
            let userProfile = try await profileService.getProfile(by: userID)
            await MainActor.run {
                self.userProfile = userProfile
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Images
extension OrdersVM {
    func fetchImages(order: CustomOrder) {
        ImageService.shared.fetchImages(
            for: order,
            designImage: { [weak self] orderID, url in
                self?.designImage[orderID] = url
            },
            attachedImage: { [weak self] orderID, url in
                self?.attachedImage[orderID] = url
            }
        )
    }
}

//MARK: - Status
extension OrdersVM {
    func updateOrderStatus(orderID: String, newStatus: String) {
        dbOrderService.updateOrderStatus(orderID: orderID, newStatus: newStatus) { [weak self] in
            DispatchQueue.main.async {
                self?.orders.first { $0.id == orderID }?.status = newStatus
            }
        }
    }
    
    func updateCustomOrderStatus(orderID: String, newStatus: String) {
        dbOrderService.updateCustomOrderStatus(orderID: orderID, newStatus: newStatus) { [weak self] in
            DispatchQueue.main.async {
                self?.customOrders.first { $0.id == orderID }?.status = newStatus
            }
        }
    }
}


//MARK: - Filters
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
        selectedStatus = status
        switch status {
        case .all:
            filteredCustomOrders = customOrders
        default:
            filteredCustomOrders = customOrders.filter { $0.status == status.rawValue }
        }
    }
}

//MARK: - Logout
extension OrdersVM {
    func logout() {
        authService.signOut{ result in
            switch result {
            case .success:
                self.showQuit = true
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}



//  File.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation
import UIKit
import SwiftUICore
import FirebaseStorage

final class OrdersVM: ObservableObject {
    private let dbOrdersService = DBOrdersService()
    private let productService = CustomProductService()
    private let authService = AuthService()
    private let dbOrderService = DBOrdersService()

    
    private var selectOrder: Order?
    @Published var selectedStatus: OrderStatus = .all

    @Published var orders: [Order] = []
    @Published var filteredOrders: [Order] = []
    @Published var customOrders: [CustomOrder] = []
    @Published var filteredCustomOrders: [CustomOrder] = []
    @Published var designImage: [String: URL] = [:]
    @Published var attachedImage: [String: URL] = [:]
   
    @Published var selectCustomOrder: CustomOrder?
   
    @Published var showQuitPresenter = false
    @Published var imageURL: URL?
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
    func fetchImages(order: CustomOrder) {
        if let designURLString = order.style?.image {
            fetchImageURL(from: designURLString) { [weak self] url in
                DispatchQueue.main.async {
                    self?.designImage[order.id] = url
                }
            }
        }
        
        if let attachedURLString = order.attachedImageURL {
            fetchImageURL(from: attachedURLString) { [weak self] url in
                DispatchQueue.main.async {
                    self?.attachedImage[order.id] = url
                }
            }
        }
    }
    
    private func fetchImageURL(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard !urlString.isEmpty else {
            completion(nil)
            return
        }
        
        let storageRef: StorageReference
        
        if urlString.hasPrefix("gs://") || urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            storageRef = Storage.storage().reference(forURL: urlString)
        } else {
            storageRef = Storage.storage().reference(withPath: urlString)
        }
        
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
}
   
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
                self?.orders.first { $0.id == orderID }?.status = newStatus
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
        selectedStatus = status
        switch status {
        case .all:
            filteredCustomOrders = customOrders
        default:
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



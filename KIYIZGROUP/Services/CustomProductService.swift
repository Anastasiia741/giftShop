//  CustomProductService.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 5/2/25.

import Foundation
import FirebaseStorage
import FirebaseFirestore

final class CustomProductService: ObservableObject {
    private var listenerRegistation: ListenerRegistration?
    private var db = Firestore.firestore()
    private let storage = Storage.storage()
    
    deinit {
        listenerRegistation?.remove()
    }
}

//MARK: - fetchCustomProducts
extension CustomProductService {
    
    func fetchCustomProducts() async throws -> [CustomProduct] {
        let querySnapshot = try await db.collection(Accesses.customDesign).getDocuments()
        var products: [CustomProduct] = []
        for document in querySnapshot.documents {
            if let product = try? document.data(as: CustomProduct.self) {
                products.append(product)
            }
        }
        return products
    }
    
    func fetchCustomStyles() async throws -> [CustomStyle] {
        let querySnapshot = try await db.collection(Accesses.customStyle).getDocuments()
        var products: [CustomStyle] = []
        for document in querySnapshot.documents {
            if let product = try? document.data(as: CustomStyle.self) {
                products.append(product)
            }
        }
        return products
    }
    
    func createOrder(_ order: CustomOrder) async throws {
        let orderData = order.representation
        try await db.collection("customOrders").document(order.id).setData(orderData)
    }
}

//MARK: - fetchCustomOrders for Admin
extension CustomProductService {
    func fetchCustomOrders() async throws -> [CustomOrder] {
        let querySnapshot = try await db.collection("customOrders").getDocuments()
        var orders: [CustomOrder] = []
        
        for document in querySnapshot.documents {
            if let order = CustomOrder(doc: document) {
                orders.append(order)
            }
        }
        return orders
    }
    
}

//MARK: - Images
extension CustomProductService {
    func uploadImageToStorage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "Ошибка преобразования изображения", code: -1, userInfo: nil)
        }
        
        let uniqueImageName = "orderImages/\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child(uniqueImageName)
        
        let _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
}


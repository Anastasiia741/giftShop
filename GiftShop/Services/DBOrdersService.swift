//  ImageView.swift
//  GiftShop
//  Created by Анастасия Набатова on 22/1/24.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class DBOrdersService {
    
    private let db = Firestore.firestore()
    private var orderHistory = [Order]()
    private var ordersRef: CollectionReference { return db.collection("orders") }
    
    public init() {}
    
    //MARK: - Save order in firebace
    func saveOrder(order: Order,
                   promocode: String,
                   completion: @escaping (Result<Order, Error>) -> ()) {
        ordersRef.document(order.id).setData(order.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.savePositions(to: order.id, positions: order.positions) { result in
                    switch result {
                    case .success(let positions):
                        print(positions.count)
                        completion(.success(order))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //MARK: - Save list of products in firebace
    func savePositions(to orderId: String,
                       positions: [Position],
                       completion: @escaping (Result<[Position], Error>) -> ()) {
        
        let positionsRef = ordersRef.document(orderId).collection("positions")
        for position in positions {
            positionsRef.document(position.id).setData(position.representation)
        }
        completion(.success(positions))
    }
    
    //MARK: - Get list of products in order for admin
    func fetchPositionsForOrder(by orderID: String, completion: @escaping (Result<[Position], Error>) -> ()) {
        
        let positionsRef = ordersRef.document(orderID).collection("positions")
        
        positionsRef.getDocuments { [weak self] qSnap, error in
            guard self != nil else { return }
            if let querySnapshop = qSnap {
                var positions = [Position]()
                for doc in querySnapshop.documents {
                    if let position = Position(doc: doc) {
                        positions.append(position)
                    }
                }
                completion(.success(positions))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Get order for admin
    func fetchUserOrders(completion: @escaping ([Order]) -> Void) {
        
        let db = Firestore.firestore()
        let ordersCollection = db.collection("orders")
        
        ordersCollection.getDocuments { [weak self] (querySnapshot, error) in
            
            if let error = error {
                print("Ошибка при загрузке заказов: \(error.localizedDescription)")
                completion([])
                return
            }
            var userOrders: [Order] = []
            for document in querySnapshot!.documents {
                if let orderId = document["id"] as? String,
                   let userId = document["userID"] as? String,
                   let dateTimestamp = document["date"] as? Timestamp,
                   let status = document["status"] as? String,
                   let promocode = document["promocode"] as? String,
                   let _ = document["cost"] as? Int
                {
                    self?.fetchPositionsForOrder(by: orderId) { result in
                        switch result {
                        case .success(let positions):
                            let date = dateTimestamp.dateValue()
                            let userOrder = Order(id: orderId, userID: userId, positions: positions, date: date, status: status, promocode: promocode)
                            
                            userOrders.append(userOrder)
                            
                            if userOrders.count == querySnapshot!.documents.count {
                                completion(userOrders)
                            }
                            
                        case .failure(let error):
                            print("Ошибка при получении позиций для заказа: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Ошибка при извлечении данных из документа")
                }
            }
        }
    }
    
    //MARK: - Change order status for admin
    func updateOrderStatus(orderID: String, newStatus: String) {
        let orderRef = db.collection("orders").document(orderID)
        orderRef.updateData(["status": newStatus]) { error in
            if let error = error {
                print("Ошибка при обновлении статуса заказа: \(error.localizedDescription)")
            } else {
                print("Статус заказа успешно обновлен")
            }
        }
    }
    
    //MARK: - Get order status for admin
    func fetchOrderStatus(orderID: String, completion: @escaping (String?) -> Void) {
        let ordersRef = db.collection("orders")
        let orderDocRef = ordersRef.document(orderID)
        orderDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let status = document.data()?["status"] as? String {
                    completion(status)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: Get odrer history for user
    func fetchOrderHistory(by userID: String?, completion: @escaping (Result<[Order], Error>) -> ()) {
        
        let ordersRef = Firestore.firestore().collection("orders")
        if let userID = userID {
            ordersRef.whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let querySnapshot = querySnapshot else {
                    completion(.success([]))
                    return
                }
                var orders = [Order]()
                var orderCount = 0
                for document in querySnapshot.documents {
                    if var order = Order(doc: document) {
                        self.fetchPositionsForOrder(by: order.id) { result in
                            switch result {
                            case .success(let positions):
                                order.positions = positions
                                orders.append(order)
                                orderCount += 1
                                if orderCount == querySnapshot.documents.count {
                                    completion(.success(orders))
                                }
                            case .failure(let error):
                                print("Ошибка при получении позиций для заказа: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        } else {
            ordersRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    completion(.success([]))
                    return
                }
                
                var orders = [Order]()
                var orderCount = 0
                for document in querySnapshot.documents {
                    if var order = Order(doc: document) {
                        self.fetchPositionsForOrder(by: order.id) { result in
                            switch result {
                            case .success(let positions):
                                order.positions = positions
                                orders.append(order)
                                orderCount += 1
                                if orderCount == querySnapshot.documents.count {
                                    completion(.success(orders))
                                }
                            case .failure(let error):
                                print("Ошибка при получении позиций для заказа: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
    }
}

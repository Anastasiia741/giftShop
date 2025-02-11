//  ImageView.swift
//  GiftShop
//  Created by Анастасия Набатова on 22/1/24.

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DBOrdersService {
    private let db = Firestore.firestore()
    private var ordersRef: CollectionReference { return db.collection(Accesses.orders) }
    
    init() {}
    
}
  
extension DBOrdersService {
    //MARK: - Save order in firebace
    func saveOrder(order: Order, promocode: String, completion: @escaping (Result<Order, Error>) -> ()) {
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
    func savePositions(to orderId: String, positions: [Position], completion: @escaping (Result<[Position], Error>) -> ()) {
        let positionsRef = ordersRef.document(orderId).collection(Accesses.positions)
        for position in positions {
            positionsRef.document(position.id).setData(position.representation)
        }
        completion(.success(positions))
    }
    
    //MARK: - Get list of products in order for admin
    func fetchPositionsForOrder(by orderID: String, completion: @escaping (Result<[Position], Error>) -> ()) {
        let positionsRef = ordersRef.document(orderID).collection(Accesses.positions)
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
        let ordersCollection = db.collection(Accesses.orders)
        ordersCollection.getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
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
                   let address = document["address"] as? String,
                   let phone = document["phone"] as? String,
                   let sity = document["sity"] as? String,
                   let appartment = document["appartment"] as? String,
                   let floor = document["floor"] as? String,
                   let comment = document["comment"] as? String,
                   let _ = document["cost"] as? Int
                {
                    self?.fetchPositionsForOrder(by: orderId) { result in
                        switch result {
                        case .success(let positions):
                            let date = dateTimestamp.dateValue()
                            let userOrder = Order(id: orderId, userID: userId, positions: positions, date: date, status: status, promocode: promocode, address: address, phone: phone, city: sity, appatment: appartment, floor: floor, comments: comment)
                            userOrders.append(userOrder)
                            if userOrders.count == querySnapshot!.documents.count {
                                completion(userOrders)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

extension DBOrdersService {
    //MARK: - Change order status for admin
    func updateOrderStatus(orderID: String, newStatus: String, completion: @escaping ()->Void) {
        let orderRef = db.collection(Accesses.orders).document(orderID)
        orderRef.updateData(["status": newStatus]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    func updateCustomOrderStatus(orderID: String, newStatus: String, completion: @escaping ()->Void) {
        let orderRef = db.collection(Accesses.customOrders).document(orderID)
        orderRef.updateData(["status": newStatus]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
}

extension DBOrdersService {
    //MARK: Get odrer history for user
    func fetchOrderHistory(by userID: String?, completion: @escaping (Result<[Order], Error>) -> ()) {
        let ordersRef = Firestore.firestore().collection(Accesses.orders)
        if let userID = userID {
            ordersRef.whereField(Accesses.userID, isEqualTo: userID).getDocuments { (querySnapshot, error) in
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
                    if let order = Order(doc: document) {
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
                                print(error.localizedDescription)
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
                    if let order = Order(doc: document) {
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
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Get order status for admin
//    func fetchOrderStatus(orderID: String, completion: @escaping (String?) -> Void) {
//        let ordersRef = db.collection(Accesses.orders)
//        let orderDocRef = ordersRef.document(orderID)
//        orderDocRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                if let status = document.data()?["status"] as? String {
//                    completion(status)
//                } else {
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//    }
//

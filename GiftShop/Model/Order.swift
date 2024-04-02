//  Order.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Order: Identifiable {
    var id: String = UUID().uuidString
    var userID: String
    var positions = [Position]()
    var date: Date
    var status = OrderStatus.new.rawValue
    var promocode: String
    
    var cost: Int {
        var sum = 0
        for position in positions {
            sum += position.cost
        }
        return sum
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userID"] = userID
        repres["date"] = Timestamp(date: date)
        repres["status"] = status
        repres["promocode"] = promocode
        repres["cost"] = cost
        return repres
    }
    
    init(id: String, userID: String, positions: [Position], date: Date, status: String, promocode: String ) {
        self.id = id
        self.userID = userID
        self.positions = positions
        self.date = date
        self.status = status
        self.promocode = promocode
    }
    
    init?(doc: DocumentSnapshot) {
        guard let data = doc.data(),
              let id = data["id"] as? String,
              let userID = data["userID"] as? String,
              let dateTimestamp = data["date"] as? Timestamp,
              let status = data["status"] as? String,
              let promocode = data["promocode"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.userID = userID
        self.positions = []
        self.date = dateTimestamp.dateValue()
        self.status = status
        self.promocode = promocode
    }
}

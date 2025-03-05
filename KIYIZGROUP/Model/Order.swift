//  Order.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseFirestore

class Order: Identifiable, Equatable, Hashable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String = UUID().uuidString
    var userID: String
    var positions = [Position]()
    var date: Date
    var status = OrderStatus.new.rawValue
    var promocode: String
    var address: String
    var phone: String
    var city: String?
    var appatment: String?
    var floor: String?
    var comments: String?
    
    var cost: Int {
        var sum = 0
        for position in positions {
            sum += position.cost
        }
        return sum
    }
    
    var totalItems: Int {
        positions.reduce(0) { $0 + $1.count }
     }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userID"] = userID
        repres["date"] = Timestamp(date: date)
        repres["status"] = status
        repres["promocode"] = promocode
        repres["cost"] = cost
        repres["address"] = address
        repres["phone"] = phone
        repres["city"] = city
        repres["appatment"] = appatment
        repres["floor"] = floor
        repres["comments"] = comments


        return repres
    }
    
    init(id: String, userID: String, positions: [Position], date: Date, status: String, promocode: String, address: String, phone: String, city: String?, appatment: String?, floor: String?, comments: String?) {
        self.id = id
        self.userID = userID
        self.positions = positions
        self.date = date
        self.status = status
        self.promocode = promocode
        self.address = address
        self.phone = phone
        self.city = city
        self.appatment = appatment
        self.floor = floor
        self.comments = comments
    }
    
    init?(doc: DocumentSnapshot) {
        guard let data = doc.data(),
              let id = data["id"] as? String,
              let userID = data["userID"] as? String,
              let dateTimestamp = data["date"] as? Timestamp,
              let status = data["status"] as? String,
              let address = data["address"] as? String,
              let phone = data["phone"] as? String,
              let city = data["city"] as? String,
              let appatment = data["appatment"] as? String,
              let floor = data["floor"] as? String,
              let comments = data["comments"] as? String,
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
        self.address = address
        self.phone = phone
        self.city = city
        self.appatment = appatment
        self.floor = floor
        self.comments = comments
        self.positions = []

        let positionsCollection = doc.reference.collection("positions")
            positionsCollection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                    return
                }
                self.positions = querySnapshot?.documents.compactMap { Position(doc: $0) } ?? []
            }
        
    }
}

//  Position.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import Foundation
import FirebaseFirestore

struct Position: Identifiable {
    let id: String
    let product: Product
    let count: Int
    let image: String?
    
    var cost: Int {
        return product.price * self.count
    }
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["count"] = count
        repres["name"] = product.name
        repres["price"] = product.price
        repres["fullPrice"] = product.fullPrice
        repres["cost"] = self.cost
        repres["image"] = image
        
        return repres
    }
    
    internal init(id: String, product: Product, count: Int, image: String?) {
        self.id = id
        self.product = product
        self.count = count
        self.image = image
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data["id"] as? String,
              let nameDict = data["name"] as? [String: String],
              let price = data["price"] as? Int,
              let fullPrice = data["fullPrice"] as? Int,
              let count = data["count"] as? Int else {
            return nil
        }
        
        let image = data["image"] as? String
        
        let product = Product(id: 0,
                              name: nameDict,
                              category: ["en": ""],
                              detail: ["en": ""],
                              price: price,
                              fullPrice: fullPrice,
                              image: image ?? "",
                              quantity: 1)
        
        self.id = id
        self.product = product
        self.count = count
        self.image = image
    }
}


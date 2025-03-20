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
        guard let id = data["id"] as? String else { return nil}
        guard let name = data["name"] as? String else { return nil}
        guard let price = data["price"] as? Int else { return nil}
        guard let fullPrice = data["fullPrice"] as? Int else { return nil }
        guard let image = data["image"] as? String else { return nil}

        let product: Product = Product( id: 0, name: ["en": name], category: ["en": ""], detail: ["en": ""], price: price, fullPrice: fullPrice, image: "", quantity: 1)
        guard let count = data["count"] as? Int else { return nil}
        
        self.id = id
        self.product = product
        self.count = count
        self.image = image
    }
}


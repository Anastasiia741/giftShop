//  Products.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import Foundation
import FirebaseFirestore

final class Product: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
          return lhs.id == rhs.id && lhs.name == rhs.name && lhs.price == rhs.price && lhs.quantity == rhs.quantity
      }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    var name: String
    var category: String
    var detail: String
    var price: Int
    var fullPrice: Int?
    var image: String?
    var quantity: Int = 1
    
    var imageURL: URL? {
        guard let image = image else { return nil }
        if image.hasPrefix("gs://") {
            return nil
        }
        return URL(string: image)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, category, detail, price, fullPrice, image, quantity
    }
    
    init(id: Int, name: String, category: String, detail: String, price: Int, fullPrice: Int, image: String? = nil, quantity: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.detail = detail
        self.price = price
        self.fullPrice = fullPrice
        self.image = image
        self.quantity = quantity
    }
}


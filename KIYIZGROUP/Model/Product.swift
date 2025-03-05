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
        case id, name, category, detail, price, image, quantity
    }
    
    init(id: Int, name: String, category: String, detail: String, price: Int, image: String? = nil, quantity: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.detail = detail
        self.price = price
        self.image = image
        self.quantity = quantity
    }
}

final class CustomProduct: Codable, Identifiable, Equatable  {
    static func == (lhs: CustomProduct, rhs: CustomProduct) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.image == rhs.image && lhs.style == rhs.style && lhs.comment == rhs.comment
    }
    
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    var name: String
    var image: String?
    var style: [String]?
    var comment: String?
    
    init(id: Int, name: String, image: String? = nil, style: [String]? = nil, comment: String? = nil) {
        self.id = id
        self.name = name
        self.image = image
        self.style = style
        self.comment = comment
    }
    
    var representation: [String: Any] {
        return [
            "id": id,
            "name": name,
            "image": image ?? ""
        ]
    }
}

extension CustomProduct {
    convenience init?(from data: [String: Any]) {
            guard let id = data["id"] as? Int,
                  let name = data["name"] as? String else {
                return nil
            }
            
            let image = data["image"] as? String
            let style = data["style"] as? [String]
            let comment = data["comment"] as? String
            
            self.init(id: id, name: name, image: image, style: style, comment: comment)
        }
}


final class CustomStyle: Codable, Identifiable, Equatable  {
    static func == (lhs: CustomStyle, rhs: CustomStyle) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.image == rhs.image
    }
    
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    var name: String?
    var image: String?
    
    init(id: Int, name: String?, image: String? = nil) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    
    var representation: [String: Any] {
        return [
            "id": id,
            "name": name ?? "",
            "image": image ?? ""
        ]
    }
}

extension CustomStyle {
    convenience init?(from data: [String: Any]) {
            guard let id = data["id"] as? Int,
                  let name = data["name"] as? String else {
                return nil
            }
            
            let image = data["image"] as? String
            
            self.init(id: id, name: name, image: image)
        }
        
}


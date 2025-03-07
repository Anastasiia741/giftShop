//  CustomProduct.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 7/3/25.

import Foundation
import FirebaseFirestore

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


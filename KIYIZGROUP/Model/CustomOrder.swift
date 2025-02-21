//  IndividualOrder.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/1/25.

import Foundation
import FirebaseFirestore

class CustomOrder: Identifiable, Codable, Equatable {
    static func == (lhs: CustomOrder, rhs: CustomOrder) -> Bool {
          return lhs.id == rhs.id && lhs.status == rhs.status
      }
    
    var id: String = UUID().uuidString
    var userID: String
    var phone: String
    var product: CustomProduct?
    var style: CustomStyle?
    var attachedImageURL: String?
    var additionalInfo: String
    var date: Date
    var status = OrderStatus.new.rawValue

    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userID"] = userID
        repres["phone"] =  phone
        repres["product"] = product?.representation ?? [:]
        repres["style"] = style?.representation ?? [:]
        repres["attachedImageURL"] = attachedImageURL ?? ""
        repres["additionalInfo"] = additionalInfo
        repres["date"] = Timestamp(date: date)
        repres["status"] = status
        
        return repres

    }
    
    
    init(id: String = UUID().uuidString, userID: String, phone: String, product: CustomProduct?, style: CustomStyle?, attachedImageURL: String?, additionalInfo: String, date: Date, status: String = OrderStatus.new.rawValue) {
        self.id = id
        self.userID = userID
        self.phone = phone
        self.product = product
        self.style = style
        self.attachedImageURL = attachedImageURL
        self.additionalInfo = additionalInfo
        self.date = date
        self.status = status
    }
    
    init?(doc: DocumentSnapshot) {
        guard let data = doc.data(),
              let id = data["id"] as? String,
              let userID = data["userID"] as? String,
              let phone = data["phone"] as? String,
              let additionalInfo = data["additionalInfo"] as? String,
              let timestamp = data["date"] as? Timestamp,
              let status = data["status"] as? String else {
            return nil
        }

        self.id = id
        self.userID = userID
        self.phone = phone
        self.additionalInfo = additionalInfo
        self.date = timestamp.dateValue()
        self.status = status

        if let productData = data["product"] as? [String: Any] {
            self.product = CustomProduct(from: productData)
            } else {
                self.product = nil
            }

        if let styleData = data["style"] as? [String: Any] {
            self.style = CustomStyle(from: styleData)
        } else {
            self.style = nil
        }

    }
    
}



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
        return [
            "id": id,
            "userID": userID,
            "phone": phone,
            "product": product?.representation ?? [:],
            "style": style?.representation ?? [:],
            "attachedImageURL": attachedImageURL ?? "",
            "additionalInfo": additionalInfo,
            "date": Timestamp(date: date),
            "status": status
        ]
    }
    

    
    init(id: String = UUID().uuidString, userID: String, phone: String, product: CustomProduct? = nil, style: CustomStyle? = nil, attachedImageURL: String?, additionalInfo: String, date: Date, status: String = OrderStatus.new.rawValue) {
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
}



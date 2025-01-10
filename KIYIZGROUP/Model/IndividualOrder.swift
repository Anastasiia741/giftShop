//  IndividualOrder.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/1/25.

import Foundation
import FirebaseFirestore

class CustomOrder: Identifiable {
    var id: String = UUID().uuidString
    var userID: String
    let design: [CustomDesign]
    let attachedPhotoURL: String?
    let additionalInfo: String
    var date: Date
    var status = OrderStatus.new.rawValue
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = id
        repres["userID"] = userID
        repres["design"] = design.map { $0.representation }
        repres["attachedPhotoURL"] = attachedPhotoURL
        repres["additionalInfo"] = additionalInfo
        repres["date"] = Timestamp(date: date)
        repres["status"] = status
        return repres
    }
    
    
    init(id: String = UUID().uuidString, userID: String, design: [CustomDesign], attachedPhotoURL: String?, additionalInfo: String, date: Date, status: String = OrderStatus.new.rawValue) {
        self.id = id
        self.userID = userID
        self.design = design
        self.attachedPhotoURL = attachedPhotoURL
        self.additionalInfo = additionalInfo
        self.date = date
        self.status = status
    }
    
    
    init?(doc: DocumentSnapshot) {
        guard let data = doc.data(),
              let id = data["id"] as? String,
              let userID = data["userID"] as? String,
              let designData = data["design"] as? [String: Any],
              let attachedPhotoURL = data["attachedPhotoURL"] as? String?,
              let additionalInfo = data["additionalInfo"] as? String,
              let dateTimestamp = data["date"] as? Timestamp,
              let status = data["status"] as? String else {
            return nil
        }
        
        
        self.id = id
        self.userID = userID
        self.design = []
        self.attachedPhotoURL = attachedPhotoURL
        self.additionalInfo = additionalInfo
        self.date = dateTimestamp.dateValue()
        self.status = status
    }
}



struct CustomDesign: Identifiable {
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    let name: String
    let imageURL: String
    
    init(id: Int = UUID().hashValue, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
    
    init?(data: [String: Any]) {
        guard let name = data["name"] as? String,
              let imageURL = data["imageURL"] as? String else {
            return nil
        }
        self.name = name
        self.imageURL = imageURL
    }
    
    var representation: [String: Any] {
        return [
            "name": name,
            "imageURL": imageURL
        ]
    }
}




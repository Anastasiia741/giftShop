//  User.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseAuth

struct NewUser: Identifiable {
    let id: String
    var name: String
    var phone: String
    var email: String
    var city: String
    var address: String
    var appatment: String?
    var floor: String?
    var comments: String?
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["phone"] = self.phone
        repres["email"] = self.email
        repres["city"] = self.city
        repres["address"] = self.address
        repres["appatment"] = self.appatment
        repres["floor"] = self.floor
        repres["comments"] = self.comments

        return repres
    }
}

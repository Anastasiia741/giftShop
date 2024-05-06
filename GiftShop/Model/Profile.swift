//  Profile.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseFirestore

class Profile: ObservableObject {
    
    public var profile: NewUser
    public var orders: [Order] = [Order]()
    
    init(profile: NewUser) {
        self.profile = profile
    }
}

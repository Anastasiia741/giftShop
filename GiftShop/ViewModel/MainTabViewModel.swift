//  mainTabViewModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseAuth

final class MainTabViewModel: ObservableObject {
    
    @Published var user: User?
    
    init(user: User?) {
        self.user = user
    }
}

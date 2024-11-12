//  mainTabViewModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseAuth

final class MainTabVM: ObservableObject {
    @Published var userID: String?
    private let authService = AuthService()
   
    func fetchUserId() {
        userID = authService.currentUser?.uid
    }
}

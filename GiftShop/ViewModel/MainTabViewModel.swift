//  mainTabViewModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseAuth

enum Users {
    static let userId = "VZ8WXQXaV9fUdkfpQwAjRhaGk9w1"
}

enum UserState {
    case admin
    case authenticated
    case notAuthenticated
}

final class MainTabViewModel: ObservableObject {
    
    @Published var user: User?
    
    init(user: User?) {
        self.user = user
    }
}

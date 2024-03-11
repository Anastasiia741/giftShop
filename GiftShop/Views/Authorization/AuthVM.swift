//  AuthVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 18/1/24.

import Foundation
import UIKit
import FirebaseAuth

final class AuthVM: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isAuth: Bool = true
    private let authService = AuthService.shared
}

extension AuthVM {
    
    func loginTapped() async {
        if isAuth {
            authService.signIn(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    print("Аутентификация прошла успешно: \(user)")
                case .failure(let error):
                    print("Ошибка аутентификации: \(error.localizedDescription)")
                }
            }
        } else {
            registerUser()
        }
    }
    
    func toggleAuthButtonTapped() {
        isAuth.toggle()
    }
    
    func disclaimerLabelTapped() {
        if let url = URL(string: "https://ilten.github.io/app-policy/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func registerUser() {
        guard !confirmPassword.isEmpty else {
            return
        }
        
        guard password == confirmPassword else {
            return
        }
        authService.signUp(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Registration succeeded: \(user)")
            case .failure(let error):
                print("Registration Error: \(error.localizedDescription)")
            }
        }
    }
}

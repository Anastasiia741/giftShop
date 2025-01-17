//  AuthorizationVM.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 16/1/25.

import Foundation
import FirebaseAuth

final class AuthorizationVM: AuthBaseVM {
    private var authService = AuthService()
    @Published var isTabViewShow = false
    
    func signIn() async {
        if let errorMessage = validateFields() {
            updateError(message: errorMessage, type: .general)
            return
        }
        updateError(message: nil, type: nil)
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.isTabViewShow.toggle()
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
}


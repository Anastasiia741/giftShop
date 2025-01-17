//  RegistrationVM.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 16/1/25.

import Foundation
import FirebaseAuth
import UIKit

final class RegistrationVM: AuthBaseVM {
    private var authService = AuthService()
    @Published var isTabViewShow = false
    
    func signUp() {
        if let errorMessage = validateFields() {
            updateError(message: errorMessage, type: .general)
            return
        }
        updateError(message: nil, type: nil)
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.resetFields()
                self?.isTabViewShow = true
            case .failure(let error):
                self?.updateError(message: "Registration failed: \(error.localizedDescription)", type: .general)
            }
        }
    }
    
    func disclaimerTapped() {
        if let url = URL(string: Accesses.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

//  RegistrationVM.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 16/1/25.

import Foundation
import FirebaseAuth
import UIKit

final class RegistrationVM: AuthBaseVM {
    private var authService = AuthService()
    var onRegistrSuccess: (() -> Void)?
    @Published var isShowConfirmView = false
}
    
//MARK: - signUp
extension RegistrationVM {
    func signUp() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let errorMessage = validateFieldsForAuth(email: trimmedEmail, password: trimmedPassword) {
            updateError(message: errorMessage, type: .general)
            return
        }
        updateError(message: nil, type: nil)
        authService.signUp(email: trimmedEmail, password: trimmedPassword) { [weak self] result in
            switch result {
            case .success(_):
                self?.isShowConfirmView = true
                self?.onRegistrSuccess?()
            case .failure(let error):
                self?.updateError(message: "Registration failed: \(error.localizedDescription)", type: .general)
            }
        }
    }
}

//MARK: - disclaimer
extension RegistrationVM {
    func disclaimerTapped() {
        if let url = URL(string: Accesses.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

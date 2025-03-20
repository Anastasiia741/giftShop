//  AuthorizationVM.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 16/1/25.

import Foundation
import FirebaseAuth

@MainActor
final class AuthorizationVM: AuthBaseVM {
    private var authService = AuthService()
    @Published var showCatalog = false
    @Published var isEmailSent: Bool = false
    @Published var isLoading: Bool = false
}

//MARK: - signIn
extension AuthorizationVM {
    func signIn(onSuccess: @escaping () -> Void) async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let errorMessage = validateFieldsForAuth(email: trimmedEmail, password: trimmedPassword) {
            DispatchQueue.main.async {
                self.updateError(message: errorMessage, type: .general)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.updateError(message: nil, type: nil)
            self.isLoading = true
        }
        
        authService.signIn(email: trimmedEmail, password: trimmedPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(_):
                    self?.showCatalog = true
                    onSuccess()
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
}

//MARK: - resetPassword
extension AuthorizationVM {
    func resetPassword(completion: @escaping (Bool, String?) -> Void) {
        guard !email.isEmpty else {
            completion(false, "Email cannot be empty.")
            return
        }
        
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines)) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.handleError(error)
                    completion(false, error.localizedDescription)
                } else {
                    self?.isEmailSent = true
                    completion(true, nil)
                }
            }
        }
    }
}

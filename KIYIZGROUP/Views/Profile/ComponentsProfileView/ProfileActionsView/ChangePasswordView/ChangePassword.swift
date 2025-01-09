//  ChangePassword.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/1/25.

import Foundation

final class ChangePassword: ObservableObject {
    private let authService = AuthService()

    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var isLoading: Bool = false
    
    func changePassword() {
        guard !currentPassword.isEmpty else {
            errorMessage = "Current password is required"
            return
        }
        guard !newPassword.isEmpty else {
            errorMessage = "New password cannot be empty"
            return
        }
        isLoading = true
        errorMessage = nil
        successMessage = nil
        authService.reauthenticateUser(currentPassword: currentPassword) { [weak self] result in
            switch result {
            case .success:
                self?.authService.updatePassword(newPassword: self?.newPassword ?? "") { updateResult in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        switch updateResult {
                        case .success:
                            self?.successMessage = "Password updated successfully!"
                            self?.resetPasswordFields()
                        case .failure(let error):
                            self?.errorMessage = "Failed to update password: \(error.localizedDescription)"
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = "Reauthentication failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func resetPasswordFields() {
        currentPassword = ""
        newPassword = ""
        errorMessage = nil
    }
}

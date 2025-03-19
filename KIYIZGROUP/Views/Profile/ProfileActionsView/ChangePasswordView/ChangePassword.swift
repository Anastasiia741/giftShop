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
            errorMessage = "current_password_is_required".localized
            return
        }
        guard !newPassword.isEmpty else {
            errorMessage = "new_password_cannot_be_empty".localized
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
                            self?.successMessage = "password_updated_successfully".localized
                            self?.resetPasswordFields()
                        case .failure(let error):
                            self?.errorMessage = "\("failed_to_update_password".localized) \(error.localizedDescription)"
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
}

extension ChangePassword {
    private func resetPasswordFields() {
        currentPassword = ""
        newPassword = ""
        errorMessage = nil
    }
}

//  AuthBaseVMm.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 16/1/25.

import Foundation

class AuthBaseVM: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var errorType: ErrorType? = nil
}

//MARK: - errors
extension AuthBaseVM {
    func validateFieldsForReg(email: String, password: String) -> String? {
        if email.isEmpty {
            return "email_cannot_be_empty".localized
        }
        if !isValidEmail(email) {
            return "invalid_email_format".localized
        }
        if password.isEmpty {
            return "password_cannot_be_empty".localized
        }
        if password.count < 6 {
            return "password_must_be_at_least_6_characters".localized
        }
        return nil
    }
    
    func validateFieldsForAuth(email: String, password: String) -> String? {
        if email.isEmpty {
            return "email_cannot_be_empty".localized
        }
        if !isValidEmail(email) {
            return "invalid_email_format".localized
        }
        if password.isEmpty {
            return "password_cannot_be_empty".localized
        }
        return nil
    }
    
    func updateError(message: String?, type: ErrorType?) {
        DispatchQueue.main.async {
            self.errorMessage = message ?? ""
            self.errorType = type
        }
    }
    
    func resetFields() {
        email = ""
        password = ""
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func handleError(_ error: Error) {
        if error.localizedDescription.contains("password") {
            updateError(message: "incorrect_password".localized, type: .password)
        } else if error.localizedDescription.contains("email") {
            updateError(message: "email_not_found".localized, type: .email)
        } else {
            updateError(message: "\(NSLocalizedString("operation_error".localized, comment: "")) \(error.localizedDescription)", type: .general)
        }
    }
}



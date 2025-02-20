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


extension AuthBaseVM {
    func validateFieldsForReg(email: String, password: String) -> String? {
        if email.isEmpty {
            return "Email cannot be empty"
        }
        if !isValidEmail(email) {
            return "Invalid email format."
        }
        if password.isEmpty {
            return "Password cannot be empty"
        }
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        return nil
    }
    
    func validateFieldsForAuth(email: String, password: String) -> String? {
        if email.isEmpty {
            return "Email cannot be empty."
        }
        if !isValidEmail(email) {
            return "Invalid email format."
        }
        if password.isEmpty {
            return "Password cannot be empty."
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
            updateError(message: "Неверный password", type: .password)
        } else if error.localizedDescription.contains("email") {
            updateError(message: "Email не найден", type: .email)
        } else {
            updateError(message: "Ошибка операции: \(error.localizedDescription)", type: .general)
        }
    }
}



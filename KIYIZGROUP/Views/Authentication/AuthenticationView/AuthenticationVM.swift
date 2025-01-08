//  AuthVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 18/1/24.

import Foundation
import FirebaseAuth
import UIKit

enum ErrorType {
    case email
    case password
    case general
}

final class AuthenticationVM: ObservableObject {
    private var authService = AuthService()
    @Published var alertModel: AlertModel?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var errorType: ErrorType? = nil
    @Published var isTabViewShow = false
    @Published var isFinalRegistration = false
    
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
                if error.localizedDescription.contains("password") {
                    self?.errorMessage = "invalid password"
                    self?.errorType = .password
                } else if error.localizedDescription.contains("email") {
                    self?.errorMessage = "invalid email"
                    self?.errorType = .email
                } else {
                    if error.localizedDescription.contains("password") || error.localizedDescription.contains("email") {
                        self?.errorMessage = "Invalid login or password. Please try again."
                        self?.errorType = .general
                    } else {
                        self?.errorMessage = error.localizedDescription
                        self?.errorType = .general
                    }
                }}
        }
    }
    
    func signUp() {
        if let errorMessage = validateFields() {
            updateError(message: errorMessage, type: .general)
            isFinalRegistration = false
            
            return
        }
        updateError(message: nil, type: nil)
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.email = ""
                self?.password = ""
                self?.isFinalRegistration = true
            case .failure(let error):
                self?.updateError(
                    message: "Registration failed: \(error.localizedDescription)",
                    type: .general
                )
            }
        }
    }
    
    func disclaimerTapped() {
        if let url = URL(string: Accesses.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func validateFields() -> String? {
        if email.isEmpty {
            return "Email cannot be empty"
        }
        
        if !isValidEmail(email) {
            return "Invalid email format."
        }
        
        if password.isEmpty {
            return "Password cannot be empty"
        }
        
        if !isValidPassword(password) {
            return "Password must be at least 6 characters."
        }
    
        return nil
    }
    
    func updateError(message: String?, type: ErrorType?) {
        DispatchQueue.main.async {
            self.errorMessage = message ?? ""
            self.errorType = type
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}


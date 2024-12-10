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

final class MainAuthVM: ObservableObject {
    private var authService = AuthService()
    @Published var alertModel: AlertModel?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var errorType: ErrorType? = nil
    
    @Published var emailNotFound = false
    @Published var navigateToPasswordView = false
    @Published var isTabViewShow = false
    
    private func configureAlertModel(with title: String, message: String?) -> AlertModel {
        AlertModel(
            title: title,
            message: message,
            buttons: [
                AlertButtonModel(title: Localization.ok, action: { [weak self] in
                    self?.alertModel = nil
                })
            ])
    }
    
    func signIn() async {
        DispatchQueue.main.async {
            self.errorMessage = ""
            self.errorType = nil
        }
        
        guard !email.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = Localization.enterEmail
                self.errorType = .email
            }
            return
        }
        
        guard !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = Localization.enterPassword
                self.errorType = .password
            }
            return
        }
        
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
        guard !confirmPassword.isEmpty else {
            return alertModel = configureAlertModel(with: Localization.attention, message: Localization.enterPasswordConfirmation)
        }
        
        guard password == confirmPassword else {
            return alertModel = configureAlertModel(with: Localization.attention, message: Localization.passwordMismatch)
        }
        
        AuthService().signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.email = ""
                self?.password = ""
                self?.confirmPassword = ""
                self?.alertModel = self?.configureAlertModel(with: Localization.congratulations, message: Localization.dataSavedSuccessfully)
            case .failure(let error):
                self?.alertModel = self?.configureAlertModel(with: Localization.registrationError, message: error.localizedDescription)
            }
        }
    }
    
    func disclaimerTapped() {
        if let url = URL(string: Accesses.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

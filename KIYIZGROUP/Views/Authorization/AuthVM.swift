//  AuthVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 18/1/24.

import Foundation
import UIKit
import FirebaseAuth

final class AuthVM: ObservableObject {
    
    private let authService = AuthService()
    @Published var alertModel: AlertModel?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isAuth = true
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
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.isTabViewShow.toggle()
            case .failure(let error):
                self?.alertModel = self?.configureAlertModel(with: Localization.registrationError, message: error.localizedDescription)
            }
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
                self?.isAuth.toggle()
            case .failure(let error):
                self?.alertModel = self?.configureAlertModel(with: Localization.registrationError, message: error.localizedDescription)
            }
        }
    }
    
    func toggleAuthButton() {
        isAuth.toggle()
    }
    
    func disclaimerTapped() {
        if let url = URL(string: Accesses.policy) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

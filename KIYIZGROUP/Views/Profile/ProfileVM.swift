//  ProfileVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import SwiftUI
import FirebaseStorage

final class ProfileVM: ObservableObject {
    
    private let authService = AuthService()
    private let dbOrdersService = DBOrdersService()
    @Published var orders: [Order] = []
    @Published var profile: NewUser?
    @Published var alertModel: AlertModel?
    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var address = ""
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var isQuitPresenter = false

    
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
    
    func fetchUserProfile() async {
        guard let currentUser = authService.currentUser else {
            return
        }
        let currentUserUID = currentUser.uid
        do {
            let user = try await ProfileService.shared.getProfile(by: currentUserUID)
            DispatchQueue.main.async {
                self.profile = user
                self.name = user.name
                self.phoneNumber = user.phone
                self.email = user.email
                self.address = user.address
            }
        } catch {
            alertModel = configureAlertModel(with: Localization.errorRetrievingUserData, message: error.localizedDescription)
        }
    }
    
    func saveProfile() async {
        guard var updatedProfile = profile else {
            return
        }
        updatedProfile.name = name
        updatedProfile.phone = phoneNumber
        updatedProfile.address = address
        
        saveProfileToFirebase(updatedProfile) { result in
            switch result {
            case .success(_):
                self.alertModel = self.configureAlertModel(with: Localization.dataSuccessfullySaved, message: nil)
            case .failure(let error):
                self.alertModel = self.configureAlertModel(with: Localization.error, message: error.localizedDescription)
            }
        }
    }
    
    func saveProfileToFirebase(_ profile: NewUser, completion: @escaping (Result<NewUser, Error>) -> ()) {
        if let email = authService.currentUser?.email {
            ProfileService.shared.setProfile(user: profile, email: email) { result in
                switch result {
                case .success(let updatedProfile):
                    completion(.success(updatedProfile))
                case .failure(let error):
                    self.alertModel = self.configureAlertModel(with: Localization.error, message: error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchOrderHistory() {
        dbOrdersService.fetchOrderHistory(by: authService.currentUser?.uid) { [weak self] result in
            switch result {
            case .success(let orderHistory):
                self?.orders = orderHistory
                self?.orders.sort { $0.date > $1.date }
            case .failure(let error):
                self?.alertModel = self?.configureAlertModel(with: Localization.errorRetrievingOrderHistory, message: error.localizedDescription)
            }
        }
    }
    
    func logout() {
        authService.signOut { result in
            switch result {
            case .success:
                print("Пользователь разлогинен!")
                self.isQuitPresenter = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showDeleteConfirmationAlert(onDelete: @escaping ()->Void) {
        alertModel = AlertModel(
            title: Localization.deleteAccount,
            buttons: [
                AlertButtonModel(title: Localization.yes, action: { [weak self] in
                    self?.deleteAccount(onDelete: onDelete)
                }),
                AlertButtonModel(title: Localization.no, action: { [weak self] in
                    self?.alertModel = nil
                })
            ]
        )
    }
    
    func deleteAccount(onDelete: @escaping () -> Void) {
        authService.deleteAccount { [weak self] result in
            switch result {
            case .success:
                self?.alertModel = AlertModel(title: Localization.accountDeleted, message: nil, buttons: [
                    AlertButtonModel(title: Localization.ok, action: {
                        onDelete()
                    })
                ])
            case .failure(_):
                self?.alertModel = self?.configureAlertModel(with: Localization.error, message: nil)
            }
        }
    }
}


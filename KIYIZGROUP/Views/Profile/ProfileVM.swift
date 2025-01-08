//  ProfileVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI
import Combine
import FirebaseStorage

@MainActor
final class ProfileVM: ObservableObject {
    private let authService = AuthService()
    private let profileService = ProfileService()
    private let dbOrdersService = DBOrdersService()
    @Published var orders: [Order] = []
    @Published var lastOrder: Order?

    @Published var profile: NewUser?
    @Published var alertModel: AlertModel?
    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var address = ""
    @Published var appartment = ""
    @Published var floor = ""
    
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var errorMessage: String? = nil
    @Published var successMessage: String? = nil
    @Published var isLoading: Bool = false
    
    
    @Published var noPendingDeliveries: Bool = false

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showQuitPresenter = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    func fetchUserProfile() async {
        guard let currentUser = authService.currentUser else { return }
        
        let currentUserUID = currentUser.uid
        do {
            let user = try await ProfileService.shared.getProfile(by: currentUserUID)
            DispatchQueue.main.async {
                self.name = user.name
                self.email = user.email
                self.phoneNumber = user.phone
                self.address = user.address
                self.appartment = user.appatment ?? ""
                self.floor = user.floor ?? ""
            }
        } catch let error as NSError {
            print("Ошибка загрузки профиля: \(error.localizedDescription)")
        }
    }
    
    private func setupBindings() {
        $name
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.saveProfile() }
            }
            .store(in: &cancellables)
        
        $phoneNumber
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.saveProfile() }
            }
            .store(in: &cancellables)
        
        $address
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.saveProfile() }
            }
            .store(in: &cancellables)
        
        $appartment
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.saveProfile() }
            }
            .store(in: &cancellables)
        
        $floor
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task { await self?.saveProfile() }
            }
            .store(in: &cancellables)
    }
    
    func saveProfile() async {
        guard var updatedProfile = profile else {
            return
        }
        updatedProfile.name = name
        updatedProfile.phone = phoneNumber
        updatedProfile.address = address
        updatedProfile.appatment = appartment
        updatedProfile.floor = floor
        
        profileService.saveProfileToFirebase(updatedProfile) { result in
            switch result {
            case .success(_):
                self.alertModel = self.configureAlertModel(with: Localization.dataSuccessfullySaved, message: nil)
            case .failure(let error):
                self.alertModel = self.configureAlertModel(with: Localization.error, message: error.localizedDescription)
            }
        }
    }
    
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
    
    func fetchOrderHistory() {
        dbOrdersService.fetchOrderHistory(by: authService.currentUser?.uid) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let orders):
                    self.orders = orders
                    self.orders.sort { $0.date > $1.date }
                    self.lastOrder = orders.first
                    self.noPendingDeliveries = orders.isEmpty || orders.allSatisfy { $0.status == OrderStatus.delivered.rawValue }
                case .failure(let error):
                    print("Failed to fetch order history: \(error.localizedDescription)")
                }
            }
        }
    }
    
//    func fetchOrderHistory() {
//        dbOrdersService.fetchOrderHistory(by: authService.currentUser?.uid) { [weak self] result in
//            switch result {
//            case .success(let orderHistory):
//                DispatchQueue.main.async {
//                    self?.orders = orderHistory
//                    self?.orders.sort { $0.date > $1.date }
//                    self?.lastOrder = orders.first
//                    self?.noPendingDeliveries = orders.isEmpty || orders.allSatisfy { $0.status == OrderStatus.delivered.rawValue }
//                }
//            case .failure(let error):
//                self?.alertModel = self?.configureAlertModel(with: Localization.errorRetrievingOrderHistory, message: error.localizedDescription)
//            }
//        }
//    }
    
    func showLogoutConfirmationAlert() {
        alertModel = AlertModel(title: "Вы действительно хотите выйти из аккаунта?", buttons: [
            AlertButtonModel(title: Localization.yes, action: { [weak self] in
                self?.logout()
            }),
            AlertButtonModel(title: Localization.no, action: { [weak self] in
                self?.alertModel = nil
            })
        ]
        )
    }
    
    func showDeleteConfirmationAlert() {
        alertModel = AlertModel(title: Localization.deleteAccount, buttons: [
            AlertButtonModel(title: Localization.yes, action: { [weak self] in
                self?.deleteAccount {
                    self?.logout()
                }
            }),
            AlertButtonModel(title: Localization.no, action: { [weak self] in
                self?.alertModel = nil
            })
        ]
        )
    }
    
    private func deleteAccount(onDelete: @escaping () -> Void) {
        authService.deleteAccount { [weak self] result in
            switch result {
            case .success:
                self?.alertModel = AlertModel(title: Localization.accountDeleted, message: nil, buttons: [
                    AlertButtonModel(title: Localization.ok, action: {
                        onDelete()
                    })
                ])
            case .failure(let error):
                self?.alertModel = self?.configureAlertModel(with: error.localizedDescription, message: nil)
            }
        }
    }
    
    private func logout() {
        authService.signOut { result in
            switch result {
            case .success:
                self.showQuitPresenter = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func resetPasswordFields() {
        currentPassword = ""
        newPassword = ""
        errorMessage = nil
    }

    private func configureAlertModel(with title: String, message: String?) -> AlertModel {
        AlertModel(title: title, message: message, buttons: [
            AlertButtonModel(title: Localization.ok, action: { [weak self] in
                self?.alertModel = nil
            })
        ])
    }
}


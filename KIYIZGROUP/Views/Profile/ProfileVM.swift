//  ProfileVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI
import Combine
import FirebaseStorage

enum ErrorTypeProfile: Identifiable {
    case dataSuccessfullySaved
    case profileFetchFailed
    case profileSaveFailed
    case profileNotLoaded
    case orderFetchFailed
    case accountDeletionFailed
    case logoutFailed
    
    var id: String {
        String(describing: self)
    }
}

@MainActor
final class ProfileVM: ObservableObject {
    private let authService = AuthService()
    private let profileService = ProfileService()
    private let dbOrdersService = DBOrdersService()
    private var cancellables = Set<AnyCancellable>()
    @Published var profile: NewUser?
    @Published var errorType: ErrorTypeProfile? = nil
    @Published var orders: [Order] = []
    @Published var lastOrder: Order?
    @Published var name = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var appatment = ""
    @Published var floor = ""
    @Published var noPendingDeliveries = false
    @Published var lastIndOrder = true
    @Published var showQuitPresenter = false
    @Published var isSaving: Bool = false
}


extension ProfileVM {
    
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
                self.appatment = user.appatment ?? ""
                self.floor = user.floor ?? ""
                self.profile = user
            }
        } catch _ as NSError {
            DispatchQueue.main.async {
                self.errorType = .profileFetchFailed
            }
        }
    }
    
    func saveProfile() async {
        guard var updatedProfile = profile else {
            DispatchQueue.main.async {
                self.errorType = .profileNotLoaded
            }
            return
        }
        updatedProfile.name = name
        updatedProfile.phone = phoneNumber
        updatedProfile.address = address
        updatedProfile.appatment = appatment
        updatedProfile.floor = floor
        
        DispatchQueue.main.async {
            self.isSaving = true
        }
        
        let startTime = Date()
        
        profileService.saveProfileToFirebase(updatedProfile) { result in
            let elapsedTime = Date().timeIntervalSince(startTime)
            let remainingTime = max(1.0 - elapsedTime, 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime) {
                self.isSaving = false
                switch result {
                case .success:
                    self.errorType = .dataSuccessfullySaved
                case .failure:
                    self.errorType = .profileSaveFailed
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
                    self.lastOrder = self.orders.first
                    self.noPendingDeliveries = orders.isEmpty || orders.allSatisfy { $0.status == OrderStatus.delivered.rawValue }
                case .failure(let error):
                    self.errorType = .orderFetchFailed
                }
            }
        }
    }
    
    func deleteAccount(onDelete: @escaping () -> Void) {
        authService.deleteAccount { [weak self] result in
            switch result {
            case .success:
                self?.logout()
                onDelete()
            case .failure(let error):
                print("Ошибка удаления аккаунта: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() {
        authService.signOut { result in
            switch result {
            case .success:
                self.showQuitPresenter = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


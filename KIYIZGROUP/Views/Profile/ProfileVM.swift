//  ProfileVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI
import Combine
import FirebaseStorage

@MainActor
final class ProfileVM: ObservableObject {
    let authService = AuthService()
    private let profileService = ProfileService()
    private let dbOrdersService = DBOrdersService()
    private let customProductService = CustomProductService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var profile: NewUser?
    @Published var errorType: ErrorTypeProfile? = nil
    
    @Published var orders: [Order] = []
    @Published var customOrders: [CustomOrder] = []
    @Published var designImage: [String: URL] = [:]
    
    @Published var name = ""
    @Published var email = ""
    @Published var phone: String = ""
    
    @Published var cities = ["bishkek".localized, "osh".localized, "naryn".localized, "talas".localized, "batken".localized]
    @Published var selectedCity: String = ""
    @Published var address = ""
    @Published var appatment = ""
    @Published var floor = ""
    @Published var comments = ""
    
    @Published var deliveries = false
    @Published var showQuit = false
    @Published var isSaving: Bool = false
}

//MARK: - User Data
extension ProfileVM {
    func fetchUserProfile() async {
        guard let currentUser = authService.currentUser else { return }
        
        let currentUserUID = currentUser.uid
        do {
            let user = try await ProfileService.shared.getProfile(by: currentUserUID)
            DispatchQueue.main.async {
                self.name = user.name
                self.email = user.email
                self.phone = user.phone
                self.selectedCity = user.city
                self.address = user.address
                self.appatment = user.appatment ?? ""
                self.floor = user.floor ?? ""
                self.comments = user.comments ?? ""
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
        updatedProfile.phone = phone
        updatedProfile.city = selectedCity
        updatedProfile.address = address
        updatedProfile.appatment = appatment
        updatedProfile.floor = floor
        updatedProfile.comments = comments
        
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
                    self.profile = updatedProfile
                    
                    self.errorType = .dataSuccessfullySaved
                case .failure:
                    self.errorType = .profileSaveFailed
                }
            }
        }
    }
}

//MARK: - User Oders
extension ProfileVM {
    func fetchOrders() {
        guard let userID = authService.currentUser?.uid else {
            return
        }
        
        dbOrdersService.fetchOrders(by: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    let sortedOrders = orders.sorted { $0.date > $1.date }
                    self?.orders = sortedOrders
                    
                    self?.deliveries = orders.isEmpty || orders.allSatisfy { $0.status == OrderStatus.delivered.rawValue }
                case .failure(_):
                    self?.errorType = .orderFetchFailed
                }
            }
        }
    }
    
    func fetchCustomOrder() {
        guard let userID = authService.currentUser?.uid else {
            return
        }
        dbOrdersService.fetchCustomOrders(by: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    let sortedOrders = orders.sorted { $0.date > $1.date }
                    self?.customOrders = sortedOrders
                    for order in orders {
                        self?.fetchImages(order: order)
                    }
                case .failure(let error):
                    print("Ошибка загрузки заказов: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchImages(order: CustomOrder) {
        ImageService.shared.fetchImages(
            for: order,
            designImage: { [weak self] orderID, url in
                self?.designImage[orderID] = url
            },
            attachedImage: { _, _ in }
        )
    }
}

//MARK: - User Action
extension ProfileVM {
    func deleteAccount(onDelete: @escaping () -> Void) {
        authService.deleteAccount { [weak self] result in
            switch result {
            case .success:
                self?.logout(mainTabVM: MainTabVM())
                onDelete()
            case .failure(let error):
                print("Ошибка удаления аккаунта: \(error.localizedDescription)")
            }
        }
    }
    
    func logout(mainTabVM: MainTabVM) {
        authService.signOut { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    mainTabVM.userID = nil
                    self.showQuit = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}







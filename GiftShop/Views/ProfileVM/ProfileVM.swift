//  ProfileVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import SwiftUI
import FirebaseStorage


final class ProfileVM: ObservableObject {
    
    @Published var orders: [Order] = []
    @Published var profile: NewUser?
    
    @Published var name = ""
    @Published var phoneNumber = ""
    @Published var address = ""
    @Published var imageURL = ""
    @Published var image: UIImage?
    
    
    static let shared = ProfileVM()
    private let authService = AuthService.shared
    private let databaseService = DBOrdersService.shared
    private let profileService = ProfileService.shared
    private let productService = ProductService.shared
    
    func fetchUserProfile() async {
        guard let currentUser = authService.currentUser else {
            return
        }
        
        let currentUserUID = currentUser.uid
        do {
            let user = try await profileService.getProfile(by: currentUserUID)
            DispatchQueue.main.async {
                self.profile = user
                self.name = user.name
                self.phoneNumber = user.phone
                self.address = user.address
            }
            
            if let imageURL = user.image {
                loadImage(from: imageURL)
            }
            
            print("Данные пользователя получены", self.imageURL)
        } catch {
            print("Ошибка при получении данных пользователя: \(error.localizedDescription)")
        }
    }

    
    func loadImage(from url: String) {
        
        guard let profileImageURL = profile?.image else {
            print("Profile image URL is nil.")
            return
        }
        
        let imageRef = Storage.storage().reference(forURL: profileImageURL)
        imageRef.downloadURL { downloadedURL, error in
            if let error = error {
                print("Error downloading image URL: \(error.localizedDescription)")
            } else if let downloadedURL = downloadedURL {
                DispatchQueue.main.async {
                    self.imageURL = downloadedURL.absoluteString
                    print("Downloaded image URL: \(downloadedURL.absoluteString)")
                }
            } else {
                print("Failed to download image URL.")
            }
        }
    }
    
    
    func saveProfile() async {
        guard var updatedProfile = profile else {
            print("Профиль пользователя не инициализирован")
            return
        }
        
        updatedProfile.name = name
        updatedProfile.phone = phoneNumber
        updatedProfile.address = address
        updatedProfile.image = imageURL
        
         saveProfileToFirebase(updatedProfile) { result in
            switch result {
            case .success(let updatedProfile):
                print("Профиль успешно сохранен:", updatedProfile)
            case .failure(let error):
                print("Ошибка при сохранении профиля:", error.localizedDescription)
            }
        }
    }
    
    func saveProfileToFirebase(_ profile: NewUser, completion: @escaping (Result<NewUser, Error>) -> ()) {
        if let email = authService.currentUser?.email {
            profileService.setProfile(user: profile, email: email) { result in
                switch result {
                    case .success(let updatedProfile):
                        print("Данные профиля успешно обновлены", updatedProfile.image ?? "")
                        completion(.success(updatedProfile))
                    case .failure(let error):
                        print("Ошибка при сохранении данных профиля: \(error.localizedDescription)")
                        completion(.failure(error))
                }
            }
        }
    }

    
    func saveProfileImage() async {
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return }
        let imageName = UUID().uuidString
        
        do {
            let imageLink = try await profileService.save(imageData: imageData, imageName)
            self.imageURL = imageLink
            
            if var updatedProfile = self.profile {
                updatedProfile.image = imageLink
                // Добавление закрывающей скобки для замыкания completion
                saveProfileToFirebase(updatedProfile) { result in
                    switch result {
                    case .success(let updatedProfile):
                        print("Профиль успешно сохранен:", updatedProfile)
                    case .failure(let error):
                        print("Ошибка при сохранении профиля:", error.localizedDescription)
                    }
                }
            }
        } catch {
            print("Ошибка при сохранении изображения профиля: \(error.localizedDescription)")
        }
    }

    
    
    func fetchOrderHistory() {
        databaseService.fetchOrderHistory(by: authService.currentUser?.uid) { [weak self] result in
            switch result {
            case .success(let orderHistory):
                self?.orders = orderHistory
                self?.orders.sort { $0.date > $1.date }
                print("Полученные заказы:")
                for order in orderHistory {
                    print("Заказ ID: \(order.id) Дата: \(order.date)")
                }
            case .failure(let error):
                print("Ошибка при получении истории заказов: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() {
        authService.signOut { result in
            switch result {
            case .success:
                print("Пользователь разлогинен!")
            case .failure(let error):
                print("Ошибка при выходе: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAccount() {
        authService.deleteAccount { result in
            switch result {
            case .success:
                print("Аккаунт успешно удален")
            case .failure(let error):
                print("Ошибка удаления аккаунта: \(error.localizedDescription)")
            }
        }
    }
    
}

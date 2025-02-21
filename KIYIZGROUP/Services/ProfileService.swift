//  ProfileService.swift
//  GiftShop
//  Created by Анастасия Набатова on 18/1/24.

import Foundation
import FirebaseFirestore

final class ProfileService {
    static let shared = ProfileService()
    private let authService =  AuthService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
}

extension ProfileService {
    func setProfile(user: NewUser, email: String, completion: @escaping (Result<NewUser, Error>) -> ()) {
        var updatedUser = user
        updatedUser.email = email
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
            }
        }
    }
    
    func saveProfileToFirebase(_ profile: NewUser, completion: @escaping (Result<NewUser, Error>) -> ()) {
        if let email = authService.currentUser?.email {
            ProfileService.shared.setProfile(user: profile, email: email) { result in
                switch result {
                case .success(let updatedProfile):
                    completion(.success(updatedProfile))
                    print("Профиль успешно сохранен в Firebase: \(updatedProfile)")
                    
                case .failure(let error):
                    print("Ошибка при сохранении профиля в Firebase: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Get profile info
    func getProfile(by userId: String? = nil) async throws -> NewUser {
        let documentIdToFetch = userId ?? authService.currentUser?.uid
        guard let documentId = documentIdToFetch else {
            throw NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован."])
        }
        
        do {
            let docSnapshot = try await usersRef.document(documentId).getDocument()
            guard let data = docSnapshot.data() else {
                throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Документ не найден."])
            }
            
            guard let userName = data["name"] as? String,
                  let id = data["id"] as? String,
                  let phone = data["phone"] as? String,
                  let email = data["email"] as? String,
                  let city = data["city"] as? String,
                  let address = data["address"] as? String else {
                throw NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Обязательные поля не найдены."])
            }
            
            let appartment = data["appatment"] as? String ?? ""
            let floor = data["floor"] as? String ?? ""
            let comments = data["comments"] as? String
            
            let user = NewUser(id: id, name: userName, phone: phone, email: email, city: city, address: address, appatment: appartment, floor: floor, comments: comments)
            return user
        } catch {
            throw error
        }
    }
}
    
    
    
    
    
//    func getProfile(by userId: String? = nil) async throws -> NewUser {
//        let documentIdToFetch = userId ?? authService.currentUser!.uid
//        do {
//            let docSnapshot = try await usersRef.document(documentIdToFetch).getDocument()
//            guard let data = docSnapshot.data() else {
//                throw NSError(domain: "", code: 404, userInfo: nil)
//            }
//            
//            guard let userName = data["name"] as? String,
//                  let id = data["id"] as? String,
//                  let phone = data["phone"] as? String,
//                  let email = data["email"] as? String,
//                  let city = data["city"] as? String,
//                  let address = data["address"] as? String else {
//                throw NSError(domain: "", code: 500, userInfo: nil)
//            }
//            let appartment = data["appatment"] as? String ?? ""
//            let floor = data["floor"] as? String ?? ""
//            let comments: String? = data["comments"] as? String
//            
//            let user = NewUser(id: id, name: userName, phone: phone, email: email, address: address, city: city, appatment: appartment, floor: floor, comments: comments)
//            return user
//        } catch {
//            print("Ошибка при получении профиля: \(error.localizedDescription)")
//            throw error
//        }
//    }
//}

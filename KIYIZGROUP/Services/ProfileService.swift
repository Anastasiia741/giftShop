//  ProfileService.swift
//  GiftShop
//  Created by Анастасия Набатова on 18/1/24.

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class ProfileService {
    
    static let shared = ProfileService()
    private let storage = Storage.storage()
    private let authService =  AuthService()
    private let db = Firestore.firestore()
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    //MARK: - Update profile info
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
    
    // MARK: - Get profile info
    func getProfile(by userId: String? = nil) async throws -> NewUser {
        let documentIdToFetch = userId ?? authService.currentUser!.uid
        do {
            let docSnapshot = try await usersRef.document(documentIdToFetch).getDocument()
            guard let data = docSnapshot.data() else {
                throw NSError(domain: "", code: 404, userInfo: nil)
            }
            guard let userName = data["name"] as? String,
                  let id = data["id"] as? String,
                  let phone = data["phone"] as? String,
                  let address = data["address"] as? String,
                  let email = data["email"] as? String else {
                throw NSError(domain: "", code: 500, userInfo: nil)
            }
            let user = NewUser(id: id, name: userName, phone: phone, address: address, email: email)
            return user
        } catch {
            throw error
        }
    }
}

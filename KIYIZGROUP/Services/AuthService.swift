//  AuthSevrice.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseAuth

final class AuthService {
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    init() {}
    
    //  MARK: - SignIn
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        auth.signIn(withEmail: email, password: password)  { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    //  MARK: - SignUp
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                let newUser = NewUser(id: result.user.uid, name: "", phone: "", email: email, city: "", address: "")
                ProfileService.shared.setProfile(user: newUser, email: email) { resultDB in
                    switch resultDB {
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    //  MARK: - SignOut
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    //  MARK: - Change password
    func reauthenticateUser(currentPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "No email found", code: 0)))
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updatePassword(newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //  MARK: - Delete account
    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void){
        guard auth.currentUser != nil else {
            return
        }
        auth.currentUser?.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

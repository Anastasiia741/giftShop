//  AuthSevrice.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation
import FirebaseAuth

final class AuthService {
    
//    static let shared = AuthService()
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
                let newUser = NewUser(id: result.user.uid,
                                      name: "",
                                      phone: "",
                                      address: "",
                                      email: email)
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

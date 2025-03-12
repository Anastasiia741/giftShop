//  ProductServise.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/1/24.

import Foundation
import FirebaseStorage
import FirebaseFirestore

final class ProductService {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var listenerRegistation: ListenerRegistration?
    private lazy var productCollection = Firestore.firestore().collection(Accesses.products)
    
    init() {}
    
    deinit {
        listenerRegistation?.remove()
    }
}

//  MARK: - Fetch product
extension ProductService {
    func fetchAllProducts() async throws -> [Product] {
        let querySnapshot = try await db.collection(Accesses.products).getDocuments()
        var products: [Product] = []
        for document in querySnapshot.documents {
            if let product = try? document.data(as: Product.self) {
                products.append(product)
            }
        }
        return products
    }
}

//  MARK: - Add product
extension ProductService {
    func add(product: Product, completion: @escaping (Error?) -> Void) throws {
        try productCollection.addDocument(from: product) { error in
            completion(error)
        }
    }
    
    func create(product: Product, completion: @escaping (Error?) -> Void) {
        let newProduct = product
        newProduct.id = UUID().hashValue
        do {
            let newDocumentRef = try productCollection.addDocument(from: product)
            product.documentID = newDocumentRef.documentID
            update(product: product, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func update(product: Product, completion: @escaping (Error?) -> Void) {
        let productID = product.id
        productCollection.whereField(Accesses.id, isEqualTo: productID).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
            } else if let snapshot = querySnapshot, !snapshot.isEmpty {
                let document = snapshot.documents.first
                document?.reference.updateData([
                    "name": product.name,
                    "category": product.category,
                    "detail": product.detail,
                    "price": product.price,
                    "fullPrice": product.fullPrice ?? 0,
                    "image": product.image ?? "",
                    "quantity": product.quantity
                ]) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(error)
            }
        }
    }
}


//  MARK: - Image
extension ProductService {
    func uploadNewImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let fileName = UUID().uuidString + ".jpg"
        let storageRef = Storage.storage().reference(forURL: Accesses.storageProducts).child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(url?.absoluteString, nil)
                }
            }
        }
    }
    
    func updateImage(_ image: UIImage, imageURL: String, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let imageRef = Storage.storage().reference(forURL: imageURL)
        
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(url?.absoluteString, nil)
                }
            }
        }
    }
}

//  MARK: - delete product
extension ProductService {
    //  MARK: - Delete product from firestore
    func delete(product: Product, completion: @escaping (Error?) -> Void) {
        let productID = product.id
        productCollection.whereField(Accesses.id, isEqualTo: productID)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error)
                } else {
                    for document in snapshot!.documents {
                        document.reference.delete { error in
                            completion(error)
                        }
                    }
                }
            }
    }
    
    //  MARK: - Delete image from storage
    func deleteImage(_ imageName: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference(forURL: Accesses.storageProducts).child(imageName)
        storageRef.delete { error in
            completion(error)
        }
    }
}

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
    //  MARK: - add collection 'product' in firebase
    func add(product: Product, completion: @escaping (Error?) -> Void) throws {
        try productCollection.addDocument(from: product) { error in
            completion(error)
        }
    }
    
    //  MARK: - create new product collection
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
    
    //  MARK: - create new product in firestore
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
    //  MARK: - Save image in storage
    func save(imageData: Data, nameImg: String, completion: @escaping (_ imageLink: String?) -> Void) {
        let storageRef = storage.reference(forURL: Accesses.storageProducts).child(nameImg)
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                completion(nil)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    //  MARK: - Upload imagelink in firestore
    func upload(image: UIImage?, url: String, completion: @escaping (String?, Error?) -> Void) {
        guard let image = image, let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil, nil)
            return
        }
        let fileName = UUID().uuidString + url + ".jpg"
        save(imageData: imageData, nameImg: fileName) { imageLink in
            if let imageLink = imageLink {
                completion(imageLink, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    //  MARK: - Upload new imagelink for firebase
    func uploadImageToFirebase(_ image: UIImage, _ imageURL: String, completion: @escaping (String?) -> Void) {
        let imageRef = Storage.storage().reference(forURL: imageURL)
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            imageRef.putData(imageData, metadata: nil) { (_, error) in
                if error != nil {
                    completion(nil)
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let url = url {
                            let newImageURL = url.absoluteString
                            completion(newImageURL)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    //  MARK: - Upload new image for storage
    func uploadNewImage(_ selectedImage: UIImage, _ imageName: String, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            completion(nil, nil)
            return
        }
        let uniqueImageURL = Accesses.storageProducts
        let storageRef = storage.reference(forURL: uniqueImageURL)
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(nil, error)
            } else {
                storageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        completion(downloadURL.absoluteString, nil)
                    } else {
                        completion(nil, nil)
                    }
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

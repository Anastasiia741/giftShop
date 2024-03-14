//  ProductServise.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/1/24.

import Foundation
import FirebaseFirestore
import FirebaseStorage

final class ProductService {
    
    private let db = Firestore.firestore()
    private let productCollection = Firestore.firestore().collection("products")
    private let storage = Storage.storage()
    private var cachedProducts: [Product] = []
    var products: Product?
    var listenerRegistation: ListenerRegistration?
    
    public init() {}
    
    //  MARK: - add collection 'product' in firebase
    func add(product: Product, completion: @escaping (Error?) -> Void) throws {
        try productCollection.addDocument(from: product) { error in
            completion(error)
        }
    }
    
    //  MARK: - Fetch and monitor changes of products from firebase
    func fetchAllProducts() async throws -> [Product] {
        if !cachedProducts.isEmpty {
            return cachedProducts
        }
        
        let querySnapshot = try await db.collection("products").getDocuments()
        
        var products: [Product] = []
        
        for document in querySnapshot.documents {
            if let product = try? document.data(as: Product.self) {
                products.append(product)
            }
        }
        self.cachedProducts = products
        return products
    }
    
    deinit {
        listenerRegistation?.remove()
    }
    
    //  MARK: - Use this method for CreateProductScreenVC
    func create(product: Product) async throws {
        do {
            let newDocumentRef = try productCollection.addDocument(from: product)
            product.documentID = newDocumentRef.documentID
            try await self.update(product: product)
        } catch {
            throw error
        }
    }
    
    //  MARK: - Сreate new product in firestore
    func update(product: Product) async throws {
        let productID = product.id
        do {
            let snapshot = try await productCollection.whereField("id", isEqualTo: productID).getDocuments()
            for document in snapshot.documents {
                var data: [String: Any] = [
                    "name": product.name,
                    "detail": product.detail,
                    "price": product.price,
                    "quantity": product.quantity
                ]
                if let image = product.image {
                    data["image"] = image
                }
                try await document.reference.updateData(data)
            }
        } catch {
            throw error
        }
    }
    
    //  MARK: - Save image in storage
    func save(imageData: Data, nameImg: String) async throws -> String {
        let storageRef = storage.reference(forURL: "gs://giftshop-d7b5d.appspot.com/productImages").child(nameImg)
        do {
            storageRef.putData(imageData, metadata: nil)
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Ошибка загрузки: ", error)
            throw error
        }
    }
    
    //  MARK: - Upload imagelink in firestore
    func upload(image: UIImage?, url: String) async throws -> String? {
        guard let image = image,
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        let fileName = UUID().uuidString + url + ".jpg"
        do {
            return try await save(imageData: imageData, nameImg: fileName)
        } catch {
            print("Ошибка при сохранении изображения: ", error)
            throw error
        }
    }
    
    //  MARK: - Upload new image for firebase
    func uploadImageToFirebase(_ image: UIImage, _ imageURL: String) async throws -> String {
        let imageRef = Storage.storage().reference(forURL: imageURL)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw Errors.invalidImageData
        }
        do {
            imageRef.putData(imageData, metadata: nil)
            let downloadURL = try await imageRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Ошибка при загрузке нового изображения в Firebase Storage: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    //  MARK: - Upload new image for storage
    func uploadNewImage(_ selectedImage: UIImage, _ imageName: String) async throws -> String? {
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        let uniqueImageURL = "gs://giftshop-d7b5d.appspot.com/productImages/"
        let storageRef = storage.reference(forURL: uniqueImageURL)
        do {
            storageRef.putData(imageData, metadata: nil)
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL.absoluteString
        } catch {
            print("Ошибка при загрузке нового изображения: ", error)
            throw error
        }
    }
    
    //  MARK: - Delete product from firestore
    func delete(product: Product) async throws {
        let productID = product.id
        productCollection.whereField("id", isEqualTo: productID)
        let snapshot = try await productCollection.whereField("id", isEqualTo: productID).getDocuments()
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
    }
    
    //  MARK: - Delete image from storage
    func deleteImage(_ imageName: String, completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference(forURL: "giftshop-d7b5d.appspot.com/productImages").child(imageName)
        storageRef.delete { error in
            completion(error)
        }
    }
    
    //  MARK: - Data parser in firebase
    func addAllProducts() {
        //        if let fileURL = Bundle.main.url(forResource: "Products", withExtension: "json") {
        //            do {
        //                let jsonData = try Data(contentsOf: fileURL)
        //                let products = try JSONDecoder().decode([Product].self, from: jsonData)
        //
        //                for product in products {
        //                    do {
        //                        try add(product: product) { error in
        //                            if let error {
        //                                print("Ошибка добавления Firestore: \(error)")
        //                            } else {
        //                                print("Добавлены продукты в Firestore: \(product.name)")
        //                            }
        //                        }
        //                        sleep(1)
        //
        //                    } catch {
        //                        print("Ошибка добавления Firestore: \(error)")
        //                    }
        //                }
        //            } catch {
        //                print("Ошибка парсинга JSON data: \(error)")
        //            }
        //        }
        
    }
}

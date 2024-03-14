//  ProductDetailEditVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Foundation
import SwiftUI
import FirebaseStorage


//protocol EditProductProtocol: AnyObject {
//    var selectedProduct: Product? { get set }
//
//    func saveButtonTapped()
//}

final class ProductDetailEditVM: ObservableObject {
    
    private let productsDB = ProductService()
    @Published var selectedProduct: Product
    @Published var isImageChange = false
    @Published var selectedImage: UIImage?
    @Published var imageURL: URL?
    
    init(selectedProduct: Product) {
        self.selectedProduct = selectedProduct
    }
    
    func updateImageDetail() {
        if let productImage = selectedProduct.image {
            let imageRef = Storage.storage().reference(forURL: productImage)
            imageRef.downloadURL { [weak self] url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let imageURL = url {
                        DispatchQueue.main.async {
                            self?.imageURL = imageURL
                        }
                    }
                }
            }
        }
    }
    
    func saveEditedProduct() async {
        do {
            try await productsDB.update(product: selectedProduct)
            print("Данные сохранены: \(String(describing: selectedProduct.name))")
            
            if isImageChange, let selectedImage = selectedImage, let imageURL = selectedProduct.image {
                do {
                    let uploadedImageURL = try await productsDB.uploadImageToFirebase(selectedImage, imageURL)
                    selectedProduct.image = uploadedImageURL
                    self.imageURL = URL(string: uploadedImageURL)
                } catch {
                    print("Ошибка при загрузке изображения в Firebase Storage: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Ошибка при обновлении данных: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func deleteProduct() async {
        do {
            try await productsDB.delete(product: selectedProduct)
            print("Товар успешно удален")
        } catch {
            print("Ошибка удаления продукта: \(error.localizedDescription)")
        }
    }
}


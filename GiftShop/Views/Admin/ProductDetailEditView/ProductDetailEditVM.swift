//  ProductDetailEditVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Foundation
import SwiftUI
import FirebaseStorage

final class ProductDetailEditVM: ObservableObject {
    
    private let productsDB = ProductService()
    @Published var selectedProduct: Product?
    @Published var selectedImage: UIImage?
    @Published var imageURL: URL?
    @Published var isImageChange = false

    init(selectedProduct: Product) {
        self.selectedProduct = selectedProduct
    }
    
    func updateImageDetail() {
        if let productImage = selectedProduct?.image {
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
    
    func saveEditedProduct() {
        guard let selectedProduct = selectedProduct else { return }
        productsDB.update(product: selectedProduct) { error in
            if let error = error {
                print("Ошибка при обновлении данных: \(error.localizedDescription)")
            } else {
                print("Данные сохранены: \(selectedProduct)")
                if self.isImageChange == true {
                    guard let selectedImage = self.selectedImage, let imageURL = selectedProduct.image else { return }
                    self.productsDB.uploadImageToFirebase(selectedImage, imageURL) { imageURL in
                        if let imageURL = imageURL {
                            self.selectedProduct?.image = imageURL
                        } else {
                            print("Ошибка при загрузке изображения в Firebase Storage.")
                        }
                    }
                }
            }
        }
    }
    
    func deleteProduct()  {
        guard let product = selectedProduct else {
            return
        }
        productsDB.delete(product: product)  { error in
            if let error = error {
                print("Ошибка удаления продукта: \(error.localizedDescription)")
            } else {
                print("Товар успешно удален")
            }
        }
    }
}

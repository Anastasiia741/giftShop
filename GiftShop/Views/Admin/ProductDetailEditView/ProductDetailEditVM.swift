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
    @Published var alertTitle = ""
    @Published var showAlert = false
    
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
                self.showAlert = true
                self.alertTitle = Localization.error
            } else {
                self.alertTitle = Localization.dataSavedSuccessfully
                self.showAlert = true
                guard let selectedImage = self.selectedImage, let imageURL = selectedProduct.image else { return }
                self.productsDB.uploadImageToFirebase(selectedImage, imageURL) { imageURL in
                    if let imageURL = imageURL {
                        self.selectedProduct?.image = imageURL
                        self.alertTitle = Localization.dataSavedSuccessfully
                    } else {
                        self.alertTitle = Localization.error
                    }
                    self.showAlert = true
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
                print(error.localizedDescription)
                self.alertTitle = Localization.error
                self.showAlert = true
            } else {
                print("Товар успешно удален")
                self.alertTitle = "Товар успешно удален"
                self.showAlert = true
            }
        }
    }
}

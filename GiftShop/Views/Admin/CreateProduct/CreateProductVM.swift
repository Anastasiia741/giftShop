//  CreateProductVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/2/24.

import Foundation
import SwiftUI
import Combine

final class CreateProductVM: ObservableObject {
    
    private var productService = ProductService()
    @Published var productImage: UIImage?
    @Published var imageURL: String?
    @Published var productName: String = ""
    @Published var productCategory: String = ""
    @Published var productPrice: String = ""
    @Published var productDetail: String = ""
    @Published var alertMessage = ""
    @Published var showAlert = false
    
    private func createProduct(_ product: Product) {
        productService.create(product: product) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Данные успешно сохранены"
                    self.showAlert = true
                    self.clearFields()
                }
            }
        }
    }
    
    private func clearFields() {
        productName = ""
        productCategory = ""
        productPrice = ""
        productDetail = ""
        productImage = nil
    }
    
    func createNewProduct() {
        guard !productName.isEmpty, !productCategory.isEmpty, !productPrice.isEmpty, let selectedImage = productImage else {
            alertMessage = "Не все поля заполнены."
            showAlert = true
            return
        }
        productService.upload(image: selectedImage, url: productName) {[weak self] uploadedImageURL, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let uploadedImageURL = uploadedImageURL {
                    let newProduct = Product(
                        id: 0,
                        name: self.productName,
                        category: self.productCategory,
                        detail: self.productDetail,
                        price: Int(self.productPrice) ?? 0,
                        image: uploadedImageURL,
                        quantity: 1)
                    self.createProduct(newProduct)
                } else if let error = error {
                    print("Ошибка при загрузке изображения:", error.localizedDescription)
                }
            }
        }
    }
}

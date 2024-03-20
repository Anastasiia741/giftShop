//  CreateProductVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/2/24.

import Foundation
import SwiftUI
import Combine

final class CreateProductVM: ObservableObject {
    
    @Published var productImage: UIImage?
    @Published var imageURL: String?
    @Published var productName: String = ""
    @Published var productCategory: String = ""
    @Published var productPrice: String = ""
    @Published var productDetail: String = ""
    private var productService = ProductService()
    
    private func isInputValid() -> Bool {
        if productName.isEmpty || productCategory.isEmpty || String(productPrice).isEmpty || productImage == nil {
            return false
        }
        if imageURL == nil {
            return false
        }
        return true
    }
    
    private func makeNewProduct() -> Product {
        return Product(
            id: 0,
            name: productName,
            category: productCategory,
            detail: productDetail,
            price: Int(productPrice) ?? 0,
            image: imageURL,
            quantity: 1)
    }
    
    func createNewProduct() {
        let newProduct = makeNewProduct()
        
        if let selectedImage = productImage, let imageURL = imageURL {
            productService.upload(image: selectedImage, url: imageURL) { [weak self] uploadedImageURL, error in
                if let uploadedImageURL = uploadedImageURL {
                    newProduct.image = uploadedImageURL
                } else if let error = error {
                    print("Ошибка при загрузке изображения:", error.localizedDescription)
                    return
                }
                self?.createProduct(newProduct)
            }
        } else {
            createProduct(newProduct)
        }
        
    }
    
    func createProduct(_ product: Product) {
        productService.create(product: product) { error in
            if let error = error {
                print("Ошибка создания продукта:", error.localizedDescription)
            } else {
                print("Продукт создан: \(product.name)")
            }
        }
    }
}

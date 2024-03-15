//  CreateProductVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/2/24.

import Foundation
import SwiftUI
import Combine

final class CreateProductVM: ObservableObject {
    
    private let productsDB = ProductService.shared
    @Published var productImage: UIImage?
    @Published var imageURL: String?
    @Published var productName: String = ""
    @Published var productCategory: String = ""
    @Published var productPrice: String = ""
    @Published var productDetail: String = ""
    
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
    
    func createNewProduct() async {
        let newProduct = makeNewProduct()
        
        if let selectedImage = productImage, let imageURL = imageURL {
            do {
                let uploadedImageURL = try await productsDB.upload(image: selectedImage, url: imageURL)
                newProduct.image = uploadedImageURL
            } catch {
                print("Ошибка при загрузке изображения:", error.localizedDescription)
                return
            }
        }
        
        do {
            try await createProduct(newProduct)
        } catch {
            print("Ошибка создания продукта:", error.localizedDescription)
        }
    }
    
    func createProduct(_ product: Product) async throws {
        try await productsDB.create(product: product)
        print("Продукт успешно создан: \(product.name)")
    }
}

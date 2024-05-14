//  ProductDetailVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import Foundation
import UIKit
import FirebaseStorage

final class ProductDetailVM: ObservableObject {
    
    @Published var product: Product
    @Published var imageURL: URL?
    @Published var count = 0
    private let orderService = OrderService()
    
    init(product: Product) {
        self.product = product
    }
    
    func updateImageDetail() {
        if let productImage = product.image {
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
    
    func addProductToCart(_ product: Product) {
        _ = orderService.addProduct(product)
    }
}

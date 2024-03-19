//  CatalogViewModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import Foundation
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

final class CatalogVM: ObservableObject {
    
    static let shared = CatalogVM()
    @Published var popularProducts: [Product] = []
    @Published var allProducts: [Product] = []
    private let productService = ProductService()
    
    func fetchAllProducts() async {
        do {
            let result = try await productService.fetchAllProducts()
            DispatchQueue.main.async {
                self.allProducts = result
                self.popularProducts = result.filter { $0.category.lowercased() == TextMessage.Menu.porularProducts }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


//  CatalogViewModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import Foundation
import FirebaseStorage
import FirebaseFirestore

@MainActor
final class CatalogVM: ObservableObject {
    @Published var popularProducts: [Product] = []
    @Published var allProducts: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var categories = [Localization.allCategories.lowercased()]
    @Published var selectedCategory = Localization.allCategories.lowercased()
    private let productService = ProductService()
}

//MARK: - fetchProducts
extension CatalogVM {
    func fetchProducts() async {
        do {
            let result = try await productService.fetchAllProducts()
            
            DispatchQueue.main.async {
                self.allProducts = result
                self.popularProducts = result.filter {
                    $0.category.lowercased() == TextMessage.Menu.porularProducts.lowercased()
                }
                let productCategories = Set(result.map { $0.category.lowercased() })
                self.categories = [Localization.allCategories.lowercased()] + productCategories.sorted()
                self.filterProducts(by: self.selectedCategory)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - filter
extension CatalogVM {
    func filterProducts(by category: String) {
        selectedCategory = category
        if category == Localization.allCategories.lowercased() {
            filteredProducts = allProducts
        } else {
            filteredProducts = allProducts.filter { $0.category.lowercased() == category.lowercased() }
        }
    }
}


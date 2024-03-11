//  ProductsRepository.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import Foundation

protocol ProductsRepositoryI {
    func save(_ products: [Product])
    func retrieve() -> [Product]
}

final class ProductsRepository: ProductsRepositoryI {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "Products"
    
    //MARK: - Public methods
    func save(_ products: [Product]) {
        do {
            let data = try encoder.encode(products)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieve() -> [Product] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            let array = try decoder.decode(Array<Product>.self, from: data)
            return array
        } catch {
            print(error)
        }
        return []
    }
}

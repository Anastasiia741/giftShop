//
//  ProductServiceTests.swift
//  KIYIZGROUPTests
//
//  Created by Анастасия Набатова on 14/5/24.
//

import XCTest
@testable import KIYIZGROUP

final class ProductServiceTests: XCTestCase {
    
    func testFetchAllProducts() async throws {
        //        let product1 = Product(id: 1, name: "Product 1", category: "сумка", detail: "", price: 100, image: "gs://giftshop-d7b5d.appspot.com/productImages/pic121.png", quantity: 1)
        //           let product2 = Product(id: 2, name: "Product 2", category: "сумка", detail: "", price: 150, image: "gs://giftshop-d7b5d.appspot.com/productImages/pic121.png", quantity: 1)
        do {
            let productService = ProductService()
            let fetchedProducts = try await productService.fetchAllProducts()
            
            XCTAssertFalse(fetchedProducts.isEmpty, "Список товаров пустой")
        } catch {
            XCTFail("Ошибка при получении товаров: \(error.localizedDescription)")
        }
    }
}
// Mock servise
// Mock model
// protocol product service

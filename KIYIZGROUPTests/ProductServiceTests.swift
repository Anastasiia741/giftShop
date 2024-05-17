//  ProductServiceTests.swift
//  KIYIZGROUPTests
//  Created by Анастасия Набатова on 14/5/24.

import XCTest
@testable import KIYIZGROUP

final class ProductServiceTests: XCTestCase {
    
    func testFetchAllProducts() async throws {
        do {
            let productService = ProductService()
            let fetchedProducts = try await productService.fetchAllProducts()
            
            XCTAssertFalse(fetchedProducts.isEmpty, "Список товаров пустой")
        } catch {
            XCTFail("Ошибка при получении товаров: \(error.localizedDescription)")
        }
    }
}

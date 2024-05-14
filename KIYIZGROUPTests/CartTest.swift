//
//  CartTesting.swift
//  KIYIZGROUPTests
//
//  Created by Анастасия Набатова on 14/5/24.
//

import XCTest
@testable import KIYIZGROUP

final class CartTest: XCTestCase {
    private let repository = ProductsRepository()
    private let orderService = OrderService()
    private var cartVM: CartVM!
    
    override func setUp() {
        super.setUp()
        cartVM = CartVM()
    }
    
    func testSaveAndRetrieveProducts() {
        let products: [Product] = [Product(id: 1, name: "Product 1", category: "сумка", detail: "", price: 100, quantity: 1),
                                   Product(id: 2, name: "Product 2", category: "сумка", detail: "", price: 100, quantity: 1)]
        repository.save(products)
        let retrievedProducts = repository.retrieve()
        
        XCTAssertEqual(retrievedProducts.count, products.count)
        XCTAssertEqual(retrievedProducts, products)
    }
    
    func testAddProduct() {
        let productToAdd = Product(id: 1, name: "Product 1", category: "сумка", detail: "", price: 100, quantity: 1)
        let updatedProducts = orderService.addProduct(productToAdd)
        
        XCTAssertTrue(updatedProducts.contains(where: { $0.id == productToAdd.id }))
    }
    
    func testRemoveProduct() {
        let productToRemove = Product(id: 1, name: "Product 1", category: "сумка", detail: "", price: 100, quantity: 1)
        var initialProducts = orderService.retreiveProducts()
        initialProducts.append(productToRemove)
        
        let updatedProducts = orderService.removeProduct(productToRemove)
        
        XCTAssertFalse(updatedProducts.contains(productToRemove))
    }
    
    func testUpdateProduct() {
        let productToUpdate = Product(id: 1, name: "Product 1", category: "сумка", detail: "", price: 100, quantity: 1)
        let updatedQuantity = 5
        var initialProducts = orderService.retreiveProducts()
        initialProducts.append(productToUpdate)
        let updatedProducts = orderService.update(productToUpdate, updatedQuantity)
        
        XCTAssertEqual(updatedProducts.first(where: { $0.id == productToUpdate.id })?.quantity, updatedQuantity)
    }
    
    func testCalculatePrice() {
        let product1 = Product(id: 1, name: "Product 1", category: "сумка", detail: "", price: 100, quantity: 1)
        let product2 = Product(id: 2, name: "Product 2", category: "сумка", detail: "", price: 150, quantity: 1)
        let expectedTotalPrice = product1.price + product2.price
        let expectedTotalQuantity = product1.quantity + product2.quantity

        repository.save([product1, product2])
        cartVM.fetchOrder()
        
        XCTAssertEqual(cartVM.productCountMessage, "\(expectedTotalPrice)")
        XCTAssertEqual(repository.retrieve().count, 2)
    }
}

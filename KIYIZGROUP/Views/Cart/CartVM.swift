//  CartVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import Foundation

@MainActor
final class CartVM: ObservableObject {
    private let orderService = OrderService()
    private let productsRepository = ProductsRepository()
    private let dbOrdersService = DBOrdersService()
    private let authService = AuthService()
    @Published var alertModel: AlertModel?
    @Published var orderProducts: [Product] = []
    @Published var productCountMessage: String = ""
    @Published var productCountPrice = ""
    @Published var promoCode = ""
    @Published var promoResultText: String = ""
    @Published var isPromoSheetVisible = false
    
    init() {}
    
    func fetchOrder() {
        orderProducts = orderService.retreiveProducts()
        productsRepository.save(orderProducts)
        let (totalPrice, _) = orderService.calculatePrice()
        productCountMessage = "\(totalPrice)"
        productCountPrice = String(orderProducts.reduce(0) { $0 + $1.price * $1.quantity })
    }
    
    func addPromoProductToOrder(for product: Product) {
        _ = orderService.addProduct(product)
        fetchOrder()
    }
    
    func updateProduct(_ product: Product, _ count: Int) {
        product.quantity = count
        if count == 0 {
            orderProducts = orderService.removeProduct(product)
        } else {
            _ = orderService.update(product, count)
            fetchOrder()
        }
    }
    
    func saveOrder(with promoCode: String?) async -> Order? {
        let userID = authService.currentUser?.uid ?? "guest"

        let order = Order(id: UUID().uuidString, userID: userID,
                          positions: orderProducts.map { position in
                                Position(id: UUID().uuidString, product: position, count: position.quantity, image: position.image ?? "")},
                          date: Date(),
                          status: OrderStatus.new.rawValue,
                          promocode: promoCode ?? "")

        guard !order.positions.isEmpty else { return nil }

        return await withCheckedContinuation { continuation in
            dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.orderProducts.removeAll()
                        self?.productsRepository.save(self?.orderProducts ?? [])
                    }
                    continuation.resume(returning: order)
                case .failure(let error):
                    print("Error saving order: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    
//    func orderButtonTapped(with promoCode: String?) async -> Order? {
//        guard let currentUser = authService.currentUser else { return nil }
//        
//        let order = Order(id: UUID().uuidString, userID: currentUser.uid,
//                          positions: orderProducts.map { position in
//            Position(id: UUID().uuidString, product: position, count: position.quantity, image: position.image ?? "")
//        },
//                          date: Date(),
//                          status: OrderStatus.new.rawValue,
//                          promocode: promoCode ?? ""
//        )
//        
//        
//        //            let order = Order(id: UUID().uuidString, userID: currentUser.uid, positions: [], date: Date(), status: OrderStatus.new.rawValue, promocode: promoCode ?? "")
//        
//        guard !order.positions.isEmpty else { return nil }
//        
//        return await withCheckedContinuation { continuation in
//            dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
//                switch result {
//                case .success(_):
//                    DispatchQueue.main.async {
//                        self?.orderProducts.removeAll()
//                        self?.productsRepository.save(self?.orderProducts ?? [])
//                    }
//                    continuation.resume(returning: order)
//                case .failure(let error):
//                    print("Error saving order: \(error.localizedDescription)")
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
    
    func applyPromoCode() -> Bool {
        let discountMessages: [String: String] = [
            "promo 10": Localization.discount10,
            "promo 20": Localization.discount20,
            "promo 30": Localization.discount30
        ]
        
        if let message = discountMessages[promoCode.lowercased()] {
            promoResultText = message
            promoCode = ""
            return true
        } else {
            promoResultText = Localization.codeDoesNotExist
            return false
        }
    }
    
}



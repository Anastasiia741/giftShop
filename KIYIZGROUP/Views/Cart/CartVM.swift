//  CartVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import Foundation

final class CartVM: ObservableObject {
    private let orderService = OrderService()
    private let productsRepository = ProductsRepository()
    private let dbOrdersService = DBOrdersService()
    private let authService = AuthService()
    @Published var alertModel: AlertModel?
    @Published var orderProducts: [Product] = []
    @Published var productCountMessage: String = ""
    @Published var promoCode: String = ""
    @Published var promoResultText: String = ""
    @Published var isPromoSheetVisible = false
    
    init() {}
    
    func fetchOrder() {
        orderProducts = orderService.retreiveProducts()
        productsRepository.save(orderProducts)
        let (totalPrice, _) = orderService.calculatePrice()
        productCountMessage = "\(totalPrice)"
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
    
//    func orderButtonTapped(with promoCode: String?) {
//        if let currentUser = authService.currentUser {
//            let order = Order(id: UUID().uuidString, userID: currentUser.uid, positions: [], date: Date(), status: OrderStatus.new.rawValue, promocode: promoCode ?? "")
//            order.positions = orderProducts.map{ position in
//                return Position(id: UUID().uuidString, product: position, count: position.quantity)
//            }
//            if order.positions.isEmpty {
//            } else {
//                dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
//                    switch result {
//                    case .success(_):
//                        self?.orderProducts.removeAll()
//                        self?.productsRepository.save(self?.orderProducts ?? [Product]())
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//    }
    
    
    func orderButtonTapped(with promoCode: String?, completion: @escaping (Order) -> Void) {
        if let currentUser = authService.currentUser {
            let order = Order(
                id: UUID().uuidString,
                userID: currentUser.uid,
                positions: [],
                date: Date(),
                status: OrderStatus.new.rawValue,
                promocode: promoCode ?? ""
                
            )
            order.positions = orderProducts.map { position in
                return Position(id: UUID().uuidString, product: position, count: position.quantity, image: position.image ?? "")
            }
            if order.positions.isEmpty {
                alertModel = AlertModel(title: "Ошибка", message: "Корзина пуста", buttons: [])
            } else {
                dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            completion(order) // Передаём созданный заказ
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    
    func applyPromoCode() {
        if promoCode.lowercased() == "promo 10" {
            promoResultText = Localization.discount10
        } else if promoCode.lowercased() == "promo 20" {
            promoResultText = Localization.discount20
        } else if promoCode.lowercased() == "promo 30" {
            promoResultText = Localization.discount30
        } else {
            promoResultText = Localization.codeDoesNotExist
        }
        promoCode = ""
    }
}



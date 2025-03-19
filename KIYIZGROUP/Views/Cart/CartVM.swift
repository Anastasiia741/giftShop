//  CartVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import Foundation

@MainActor
final class CartVM: ObservableObject {
    private let orderService = OrderService()
    private let profileVM = ProfileVM()
    private let productsRepository = ProductsRepository()
    private let dbOrdersService = DBOrdersService()
    private let authService = AuthService()
    @Published var orderProducts: [Product] = []
    @Published var productCountMessage: String = ""
    @Published var productCountPrice = ""
    @Published var promoCode = ""
    @Published var promoResultText = ""
    
    @Published var selectedCity: String = ""
    @Published var address = ""
    @Published var appatment: String = ""
    @Published var floor: String = ""
    @Published var comments: String = ""
    @Published var phone = ""
    
    @Published var isPromoSheetVisible = false
    
    init() {
        fetchGuestData()
    }
}

//MARK: - Manage Order
extension CartVM {
    func fetchOrder() {
        orderProducts = orderService.retreiveProducts()
        productsRepository.save(orderProducts)
        let (totalPrice, _) = orderService.calculatePrice()
        productCountMessage = "\(totalPrice)"
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
}

//MARK: - Promo Code
extension CartVM {
    func addPromoProductToOrder(for product: Product) {
        _ = orderService.addProduct(product)
        fetchOrder()
    }
    
    func applyPromoCode() -> Bool {
        let discountMessages: [String: String] = [
            "promo 10": "10%_discount".localized,
            "promo 20": "20%_discount".localized,
            "promo 30": "30%_discount".localized
        ]
        
        if let message = discountMessages[promoCode.lowercased()] {
            promoResultText = message
            promoCode = ""
            return true
        } else {
            promoResultText = "there_is_no_such_code".localized
            return false
        }
    }
}

//MARK: - Save Data
extension CartVM {
    
    func saveOrder(with promoCode: String?, profileVM: ProfileVM) async -> Order? {
        let isUserLoggedIn = profileVM.authService.currentUser != nil
        
        let order = Order(
            id: UUID().uuidString,
            userID: isUserLoggedIn ? profileVM.authService.currentUser!.uid : "guest",
            positions: orderProducts.map { Position(id: UUID().uuidString, product: $0, count: $0.quantity, image: $0.image ?? "") },
            date: Date(),
            status: OrderStatus.new.rawValue,
            promocode: promoCode ?? "",
            address: isUserLoggedIn ? profileVM.address : address,
            phone: isUserLoggedIn ? profileVM.phone : phone,
            city: isUserLoggedIn ? profileVM.selectedCity : selectedCity,
            appatment: isUserLoggedIn ? profileVM.appatment : appatment,
            floor: isUserLoggedIn ? profileVM.floor : floor,
            comments: isUserLoggedIn ? profileVM.comments : comments
        )
        
        guard !order.positions.isEmpty else { return nil }
        
        return await withCheckedContinuation { continuation in
            dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
                DispatchQueue.main.async {
                    if case .success = result {
                        self?.orderProducts.removeAll()
                        self?.productsRepository.save(self?.orderProducts ?? [])
                        continuation.resume(returning: order)
                    } else if case let .failure(error) = result {
                        print("Error saving order: \(error.localizedDescription)")
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
    }
    
    func fetchGuestData() {
        address = UserDefaults.standard.string(forKey: "guestAddress") ?? ""
        phone = UserDefaults.standard.string(forKey: "guestPhone") ?? ""
        selectedCity = UserDefaults.standard.string(forKey: "guestCity") ?? ""
        appatment = UserDefaults.standard.string(forKey: "guestAppartment") ?? ""
        floor = UserDefaults.standard.string(forKey: "guestFloor") ?? ""
        comments = UserDefaults.standard.string(forKey: "guestComments") ?? ""
    }
    
    func saveGuestData() {
        UserDefaults.standard.set(address, forKey: "guestAddress")
        UserDefaults.standard.set(phone, forKey: "guestPhone")
        UserDefaults.standard.set(selectedCity, forKey: "guestCity")
        UserDefaults.standard.set(appatment, forKey: "guestAppartment")
        UserDefaults.standard.set(floor, forKey: "guestFloor")
        UserDefaults.standard.set(comments, forKey: "guestComments")
    }
}










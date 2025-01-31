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
    
    init() {}
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

//MARK: - Save Data
extension CartVM {
    func saveOrder(with promoCode: String?) async -> Order? {
           loadUserData()

           let userID = authService.currentUser?.uid ?? "guest"
           let order = Order(
               id: UUID().uuidString,
               userID: userID,
               positions: orderProducts.map { position in
                   Position(
                       id: UUID().uuidString,
                       product: position,
                       count: position.quantity,
                       image: position.image ?? ""
                   )
               },
               date: Date(),
               status: OrderStatus.new.rawValue,
               promocode: promoCode ?? "",
               address: address,
               phone: phone,
               city: selectedCity,
               appatment: appatment,
               floor: floor,
               comments: comments
               
           )

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
    
    func loadUserData() {
        if authService.currentUser != nil {
            address = profileVM.address
            selectedCity = profileVM.selectedCity
            appatment = profileVM.appatment
            floor = profileVM.floor
            comments = profileVM.comments
            phone = profileVM.phone
        } else {
            fetchGuestData()
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
    
    



//    func saveOrder(with promoCode: String?) async -> Order? {
//        saveUserData()
//
//        let userID = authService.currentUser?.uid ?? "guest"
//        let order = Order(
//            id: UUID().uuidString,
//            userID: userID,
//            positions: orderProducts.map { position in
//                Position(
//                    id: UUID().uuidString,
//                    product: position,
//                    count: position.quantity,
//                    image: position.image ?? ""
//                )
//            },
//            date: Date(),
//            status: OrderStatus.new.rawValue,
//            promocode: promoCode ?? "",
//            address: address
//        )
//
//        guard !order.positions.isEmpty else { return nil }
//
//        return await withCheckedContinuation { continuation in
//            dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
//                switch result {
//                case .success:
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






    //    func saveOrder(with promoCode: String?) async -> Order? {
    //        let userID = authService.currentUser?.uid ?? "guest"
    //
    //        let order = Order(id: UUID().uuidString, userID: userID,
    //                          positions: orderProducts.map { position in
    //            Position(id: UUID().uuidString, product: position, count: position.quantity, image: position.image ?? "")},
    //                          date: Date(),
    //                          status: OrderStatus.new.rawValue,
    //                          promocode: promoCode ?? "")
    //
    //        guard !order.positions.isEmpty else { return nil }
    //
    //        return await withCheckedContinuation { continuation in
    //            dbOrdersService.saveOrder(order: order, promocode: order.promocode) { [weak self] result in
    //                switch result {
    //                case .success:
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
    
   




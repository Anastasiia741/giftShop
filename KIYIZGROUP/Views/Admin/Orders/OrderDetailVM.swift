//  OrderDetailVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import Foundation
//
//@MainActor
//final class OrderDetailVM: ObservableObject {
//    private let profileService = ProfileService()
//    private let orderService = OrderService()
//    @Published var selectOrder: Order?
//    @Published var userProfile: NewUser?
//    
//    func fetchUserProfile() async {
//        guard let userID = selectOrder?.userID else { return }
//        do {
//            let userProfile = try await profileService.getProfile(by: userID)
//            DispatchQueue.main.async {
//                self.userProfile = userProfile
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}

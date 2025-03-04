//  OrderDetail.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/2/24.

import SwiftUI


struct OrderDetail: View {
    @StateObject var viewModel: OrdersVM
    private let textComponent = TextComponent()
    @State var order: Order
    @State private var showStatusAlert = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    OrderHeaderSection(textComponent: textComponent)
                    OrderDetailsAdminSection(order: order, viewModel: viewModel, textComponent: textComponent)
                    GoodsSection(order: order, textComponent: textComponent)
                }
                Spacer()
            }
            HStack {
                OrderStatusButton(viewModel: viewModel, status: order.status, orderID: order.id, isCustomOrder: false)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct OrderDetailsAdminSection: View {
    let order: Order
    let viewModel: OrdersVM
    let textComponent: TextComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            orderDateView
            orderStatusView
            promoCodeView
            nameView
            addressView
            phoneView
            emailView
            CustomDivider()
            sumView
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .adaptiveStroke()
        .padding(.horizontal)
    }
    
    private var orderDateView: some View {
        textComponent.createText(text: "\(Localization.orderDate) \(Extentions().formattedDate(order.date))", fontSize: 18, fontWeight: .regular, lightColor: .black, darkColor: .white)
    }
    
    private var orderStatusView: some View {
        HStack {
            textComponent.createText(text: Localization.status, fontSize: 18, fontWeight: .regular, lightColor: .black, darkColor: .white)
            
            textComponent.createText(text: order.status, fontSize: 18, fontWeight: .regular,
                                     lightColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new),
                                     darkColor: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
        }
    }
    
    private var promoCodeView: some View {
        textComponent.createText(text: "\(Localization.promoCode): \(order.promocode.isEmpty ? "нет" : order.promocode)", fontSize: 18, fontWeight: .regular, lightColor: .black, darkColor: .white)
    }

    private var nameView: some View {
        textComponent.createText(text: "\(Localization.name) \(viewModel.userProfile?.name ?? "-")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
    }
    
    private var addressView: some View {
        textComponent.createText(text: "\(Localization.deliveryAddress) \(order.address)", fontSize: 18, fontWeight: .regular, lightColor: .black, darkColor: .white)
    }

    private var phoneView: some View {
        textComponent.createText(text: "\(Localization.phoneNumber) \(order.phone)", fontSize: 18, fontWeight: .regular, lightColor: .black, darkColor: .white)
    }
    
    private var emailView: some View {
        textComponent.createText(text: "\(Localization.email) \(viewModel.userProfile?.email ?? "-")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
    }
    
    private var sumView: some View {
        textComponent.createText(text: "\(Localization.sum) \(viewModel.selectOrder?.cost ?? .zero) \(Localization.som)", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
    }
}

struct GoodsSection: View {
    let order: Order
    let textComponent: TextComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            textComponent.createText(text: Localization.goods, fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(order.positions) { position in
                HStack {
                    textComponent.createText(text: "\(Localization.title) \(position.product.name): \(position.count) \(Localization.amount).", fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

//struct UserInfoSection: View {
//    @ObservedObject var viewModel: OrdersVM
//    let textComponent: TextComponent
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            textComponent.createText(
//                text: "\(Localization.name): \(viewModel.userProfile?.name ?? "-")",
//                fontSize: 18,
//                fontWeight: .bold,
//                lightColor: .black,
//                darkColor: .white
//            )
//            textComponent.createText(
//                text: "\(Localization.email): \(viewModel.userProfile?.email ?? "-")",
//                fontSize: 18,
//                fontWeight: .bold,
//                lightColor: .black,
//                darkColor: .white
//            )
//            textComponent.createText(
//                text: "\(Localization.deliveryAddress): \(viewModel.userProfile?.address ?? "-")",
//                fontSize: 18,
//                fontWeight: .bold,
//                lightColor: .black,
//                darkColor: .white
//            )
//            textComponent.createText(
//                text: "\(Localization.phoneNumber): \(viewModel.userProfile?.phone ?? "-")",
//                fontSize: 18,
//                fontWeight: .bold,
//                lightColor: .black,
//                darkColor: .white
//            )
//            textComponent.createText(
//                text: "\(Localization.sum): \(viewModel.selectOrder?.cost ?? .zero) \(Localization.som)",
//                fontSize: 18,
//                fontWeight: .bold,
//                lightColor: .black,
//                darkColor: .white
//            )
//            .padding(.top)
//        }
//        .padding()
//        .adaptiveStroke()
//        .padding(.horizontal)
//    }
//}




//struct OrderDetail: View {
//    @StateObject var viewModel: OrdersVM
//    @State var order: Order
//    private let textComponent = TextComponent()
//    
////    @ObservedObject var viewModel: OrderDetailVM
//    @ObservedObject var orderViewModel: OrdersVM
//    @State private var showStatusAlert = false
//    
//   
//    var body: some View {
//        VStack(spacing: 10) {
//            
//            OrderHeaderSection(textComponent: textComponent)
//
//        
//            VStack( spacing: 10) {
//                textComponent.createText(text: "\(Localization.orderDate) \(Extentions().formattedDate( ?? Date()))", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                HStack {
//                    textComponent.createText(text: Localization.status, fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    
//                    textComponent.createText(text: viewModel.selectOrder?.status ?? "", fontSize: 18, fontWeight: .bold,
//                                             lightColor: StatusColors.getTextColor(OrderStatus(rawValue: viewModel.selectOrder?.status ?? "") ?? .new),
//                                             darkColor: StatusColors.getTextColor(OrderStatus(rawValue: viewModel.selectOrder?.status ?? "") ?? .new))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                textComponent.createText(text: "\(Localization.promoCode): \(viewModel.selectOrder?.promocode ?? "нет")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding(.horizontal)
//            
//            VStack(spacing: 10) {
//                textComponent.createText(text: Localization.goods, fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                ForEach(viewModel.selectOrder?.positions ?? []) { position in
//                    HStack {
//                        textComponent.createText(text: "\(Localization.title) \(position.product.name): \(position.count) \(Localization.amount).", fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//            }
//            .padding()
//            .background(Color.gray.opacity(0.2))
//            .cornerRadius(10)
//            .padding(.horizontal)
//            .padding(.vertical, 5)
//            VStack( spacing: 10) {
//                textComponent.createText(text: "\(Localization.name): \(viewModel.userProfile?.name ?? "")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                textComponent.createText(text: "\(Localization.email) \(viewModel.userProfile?.email ?? "")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                textComponent.createText(text: "\(Localization.deliveryAddress) \(viewModel.userProfile?.address ?? "")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                textComponent.createText(text: "\(Localization.phoneNumber) \(viewModel.userProfile?.phone ?? "")", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                textComponent.createText(text: "\(Localization.sum) \(viewModel.selectOrder?.cost ?? .zero) \(Localization.som)", fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
//                    .padding(.top)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding(.leading)
//            Spacer()
//        }
//        
//        HStack {
////            OrderStatusButton(viewModel: viewModel, isCustomOrder: true, orderID: order.id, status: order.status)
//            }
//        
//        Button(action: {
//            showStatusAlert = true
//        }) {
//            Text("\(viewModel.selectOrder?.status ?? "")")
//                .font(.system(size: 18))
//                .fontWeight(.medium)
//                .frame(maxWidth: 130, minHeight: 50)
//                .foregroundColor(.white)
//                .background(Color(StatusColor.new))
//                .cornerRadius(20)
//                .shadow(color: Color(StatusColor.new).opacity(0.5), radius: 5, x: 0, y: 5)
//        }
//        .padding(.bottom, 22)
//    }
//}
//




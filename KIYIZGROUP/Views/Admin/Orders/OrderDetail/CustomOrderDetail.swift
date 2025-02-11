//  CustomOrderDetail.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 7/2/25.

import SwiftUI

struct CustomOrderDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: OrdersVM
    private let textComponent = TextComponent()
    @State var order: CustomOrder

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    OrderHeaderSection(colorScheme: colorScheme, textComponent: textComponent)
                    CustomOrderDetailsSection(order: order, colorScheme: colorScheme, textComponent: textComponent)
                    ImageSection(title: "Дизайн", imageURL: viewModel.designImage[order.id])
                    ImageSection(title: "Добавленое изображение", imageURL: viewModel.attachedImage[order.id])
                    CommentSection(order: order, colorScheme: colorScheme, textComponent: textComponent)
                    
                }
                Spacer()
            }
            HStack {
                OrderStatusButton(viewModel: viewModel, status: order.status, orderID: order.id, isCustomOrder: true)
            }
            .frame(maxWidth: .infinity, alignment: .center)
           
            .task {
                viewModel.fetchImages(order: order)
            }
        }
    }
}

struct OrderHeaderSection: View {
    let colorScheme: ColorScheme
    let textComponent: TextComponent
    
    var body: some View {
        textComponent.createText(text: Localization.orderDetails, fontSize: 22, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
            .padding(.horizontal)
            .padding(.top, 16)
    }
}

struct CustomOrderDetailsSection: View {
    let order: CustomOrder
    let colorScheme: ColorScheme
    let textComponent: TextComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            orderDateView
            orderStatusView
            productView
            phoneNumberView
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .padding(.horizontal)
    }
    
    private var orderDateView: some View {
        let orderDateText = "\(Localization.orderDate) \(Extentions().formattedDate(order.date))"
        return textComponent.createText(text: orderDateText, fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
    }
    
    private var orderStatusView: some View {
        HStack {
            textComponent.createText(text: Localization.status, fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            
            textComponent.createText(text: order.status, fontSize: 18, fontWeight: .regular, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
        }
    }
    
    private var productView: some View {
        Group {
            if let product = order.product {
                textComponent.createText(text: "Продукт: \(product.name)", fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
        }
    }
    
    private var phoneNumberView: some View {
        Group {
            if !order.phone.isEmpty {
                textComponent.createText(text: "Телефон: \(order.phone)", fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
        }
    }
}

struct CommentSection: View {
    let order: CustomOrder
    let colorScheme: ColorScheme
    let textComponent: TextComponent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "Комментарий", fontSize: 16, fontWeight: .regular, color: .gray)
            
            textComponent.createText(text: order.additionalInfo, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .padding(.horizontal)
    }
}


struct ImageSection: View {
    private let textComponent = TextComponent()
    let title: String
    let imageURL: URL?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            textComponent.createText(text: title, fontSize: 16, fontWeight: .bold, color: .black)
            Spacer()
            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    textComponent.createText(text: "Нет", fontSize: 12, fontWeight: .bold, color: .gray)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .padding(.horizontal)
    }
}


struct OrderStatusButton: View {
    @ObservedObject var viewModel: OrdersVM
    private let textComponent = TextComponent()
    @State var status: String
    let orderID: String
    let isCustomOrder: Bool
    @State private var isShowStatus = false
    
    var body: some View {
        Button(action: {
            isShowStatus = true
        }) {
            textComponent.createText(text: status, fontSize: 16, fontWeight: .medium, color: .white)
                .frame(maxWidth: 130, minHeight: 50)
                .background(StatusColors.getTextColor(OrderStatus(rawValue: status) ?? .new))
                .cornerRadius(20)
        }
        .actionSheet(isPresented: $isShowStatus) {
            ActionSheet(
                title: Text(Localization.selectOrderStatus),
                buttons: OrderStatus.allCases.map { orderStatus in
                        .default(Text(orderStatus.rawValue)) {
                            updateStatus(orderStatus.rawValue)
                        }
                } + [.cancel()]
            )
        }
        .padding(.bottom, 22)
    }
    
    private func updateStatus(_ newStatus: String) {
        if isCustomOrder {
            viewModel.updateCustomOrderStatus(orderID: orderID, newStatus: newStatus)
        } else {
            viewModel.updateOrderStatus(orderID: orderID, newStatus: newStatus)
        }
        status = newStatus
    }
}


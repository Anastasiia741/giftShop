//  CustomDetailsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 6/2/25.

import SwiftUI

struct CustomDetailsView: View {
    @ObservedObject var viewModel: CustomProductVM
    @State private var designImage: UIImage? = nil
    let customOrder: CustomOrder
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CustomBackButton()
                Spacer()
            }
            .padding([.leading, .top], 8)
            
            CustomHeaderView(title: "Заказ")
                .padding(.top, 4)
            
            OrderDetailsSection(
                productType: viewModel.selectedProduct?.name ?? "Не выбран",
                comment: viewModel.comment,
                designImage: designImage
            )
            
            VStack(alignment: .leading, spacing: 16) {
                CustomDetailView(viewModel: viewModel, customOrder: customOrder)
            }
            Spacer()
            
                .padding(.top, 4)
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

//#Preview {
//    let customOrder = CustomOrder(
//        userID: UUID().uuidString,
//        phone: "dcdcdec",
//        attachedImageURL: "",
//        additionalInfo: "",
//        date: Date() 
//    )
//    let viewModel = CustomProductVM()
//    
//    CustomDetailsView(viewModel: viewModel, customOrder: customOrder)
//}


struct CustomDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: CustomProductVM
//    @StateObject var statusColors = StatusColors()
    private let statusColors = StatusColors() // ✅ Correct

    private let textComponent = TextComponent()
    let customOrder: CustomOrder
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView
            
            orderDetails
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3),
                            lineWidth: 1.5
                        )
                )
        }
    }
    
    private var headerView: some View {
        textComponent.createText(
            text: "Детали",
            fontSize: 21,
            fontWeight: .bold,
            style: .headline,
            color: colorScheme == .dark ? .white : .black
        )
        .padding(.vertical)
    }
    
    private var orderDetails: some View {
        VStack(spacing: 16) {
            detailRow(
                label: Localization.status,
                value: "\(customOrder.status)",
                valueColor: StatusColors.getTextColor(OrderStatus(rawValue: customOrder.status) ?? .new)
            )
            detailRow(
                label: "Номер заказа",
                value: "\(customOrder.id.prefix(6))"
            )
            detailRow(
                label: "Дата и время заказа",
                value: Extentions().formattedDate(customOrder.date)
            )
            CustomDivider()
            detailRow(
                label: "Телефон",
                value: customOrder.phone
            )
        }
    }
    
    private func detailRow(label: String, value: String, valueColor: Color? = nil) -> some View {
        HStack {
            textComponent.createText(
                text: label,
                fontSize: 16,
                fontWeight: .regular,
                color: colorScheme == .dark ? .white : .black
            )
            Spacer()
            textComponent.createText(
                text: value,
                fontSize: 16,
                fontWeight: .regular,
                color: valueColor ?? (colorScheme == .dark ? .white : .black)
            )
        }
    }
}

//struct CustomDetailView: View {
//    @Environment(\.colorScheme) var colorScheme
//    @StateObject var viewModel: CustomProductVM
//    
//    @StateObject var statusColors = StatusColors()
//    private let textComponent = TextComponent()
//    let customOrder: CustomOrder
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            textComponent.createText(text: "Детали", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
//                .padding(.vertical)
//            VStack {
//                HStack {
//                    textComponent.createText(text: Localization.status, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                    Spacer()
//                    textComponent.createText(text: "\(customOrder.status)", fontSize: 16, fontWeight: .regular, color: statusColors.getTextColor(OrderStatus(rawValue: customOrder.status) ?? .new))
//                }
//                HStack {
//                    textComponent.createText(text: "Номер заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                    Spacer()
//                    textComponent.createText(text: "\(customOrder.id.prefix(6))", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                    
//                }
//                .padding([.vertical])
//                HStack {
//                    textComponent.createText(text: "Дата и время заказа", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                    Spacer()
//                    textComponent.createText(text: "\(Extentions().formattedDate(viewModel.customOrder.date))", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                }
//                CustomDivider()
//                
//                
//                //                .padding(.top)
//                HStack {
//                    textComponent.createText(text: "Телефон", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                    Spacer()
//                    textComponent.createText(text: "\(viewModel.customOrder.phone)", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
//                }
//                .padding(.vertical)
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
//            )
//        }
//    }
//}
//    

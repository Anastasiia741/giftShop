//  CustomOrderDetail.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 7/2/25.

import SwiftUI

struct CustomOrderDetail: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    @State private var designImage: UIImage?
    let order: CustomOrder
    
    var body: some View {
        VStack(spacing: 10) {
            textComponent.createText(text: Localization.orderDetails, fontSize: 22, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                .padding([.top, .leading])
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 10) {
                textComponent.createText(text: "\(Localization.orderDate) \(Extentions().formattedDate(order.date))", fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                HStack {
                    textComponent.createText(text: Localization.status, fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    
                    textComponent.createText(text: order.status, fontSize: 18, fontWeight: .regular, color: StatusColors.getTextColor(OrderStatus(rawValue: order.status) ?? .new))
                }
                
                if let product = order.product {
                    textComponent.createText(
                        text: "Продукт: \(product.name)", fontSize: 18, fontWeight: .regular, color: .black
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
            .padding(.horizontal)
            
            if let designImage = designImage {
                Image(uiImage: designImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ProgressView("Загрузка изображения...")
                    .padding()
            }
            
            
            
            
            VStack(alignment: .leading) {
                textComponent.createText(text: "Комментарий", fontSize: 16, fontWeight: .regular, color: .gray)
                    .padding(.vertical, 4)
                textComponent.createText(text: order.additionalInfo, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
        .task {
            self.designImage = await fetchOrderImage(for: order)
        }
        
    }
    
    @MainActor
    private func fetchOrderImage(for order: CustomOrder) async -> UIImage? {
        guard let imageURLString = order.attachedImageURL,
              let imageURL = URL(string: imageURLString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            if let image = UIImage(data: data) {
                return image
            }
        } catch {
            print("❌ Ошибка загрузки изображения: \(error.localizedDescription)")
        }
        return nil
    }
}



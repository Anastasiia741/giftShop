//  OrderItems.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/1/25.

import SwiftUI
import Kingfisher

struct OrderItems: View {
    private let textComponent = TextComponent()
    @StateObject private var orderItemsVM = OrderItemsVM()
    let order: Order
    
    var body: some View {
        VStack(spacing: 16) {
            textComponent.createText(text: "Товары", fontSize: 22, fontWeight: .bold, lightColor: .black, darkColor: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(order.positions, id: \.id) { position in
                        VStack {
                            if let imageURL = orderItemsVM.imageURLs[position.id] {
                                KFImage(imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 97, height: 111)
                                    .clipped()
                                    .cornerRadius(24)
                            } else {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 97, height: 111)
                            }
                            textComponent.createText(text: position.product.name, fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
                                .lineLimit(1)
                                .padding(.vertical, 6)
                            textComponent.createText(text: "\(position.count) шт.", fontSize: 12, fontWeight: .regular, lightColor: .gray, darkColor: .white)
                        }
                        .onAppear {
                            orderItemsVM.fetchImage(for: position)
                        }
                    }
                }
                .padding()
                textComponent.createText(text: "Сумма: \(order.cost) сом", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
        }
    }
}




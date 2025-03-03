//  OrderSummaryView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct OrderSummaryView: View {
    @ObservedObject var viewModel: CartVM
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack {
            textComponent.createText(text: "Итого", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 16) {
                VStack(spacing: 12) {
                    ForEach(viewModel.orderProducts, id: \.id) { product in
                        HStack {
                            textComponent.createText(text: "\(product.name)", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                            Spacer()
                            textComponent.createText(text: "\(product.price * product.quantity) сом", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                        }
                    }
                    HStack {
                        textComponent.createText(text: "Доставка", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                        Spacer()
                        textComponent.createText(text: "Бесплатно", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    }
                }
                .padding()
                Divider()
                    .padding(.horizontal)
                    .background(.gray)
                HStack {
                    textComponent.createText(text: "Общая сумма", fontSize: 16, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                    Spacer()
                    textComponent.createText(text: "\(viewModel.productCountMessage) сом", fontSize: 16, fontWeight: .bold, style: .headline,  lightColor: .black, darkColor: .white)
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
        }
    }
}

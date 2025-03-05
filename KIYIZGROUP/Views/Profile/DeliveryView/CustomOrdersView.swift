//  CustomOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/1/25.

import SwiftUI

struct CustomOrdersView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = ProfileVM()
    @State private var selectedOrder: CustomOrder?
    private let statusColors = StatusColors()
    private let textComponent = TextComponent()
    @Binding var currentTab: Int

    var body: some View {
        VStack {
            HStack {
                CustomBackButton()
                Spacer()
            }
            .padding([.leading, .top], 16)
            Spacer()
            
            textComponent.createText(text: "Заказы", fontSize: 26, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            List(viewModel.customOrders) { order in
                CustomOrderRow(order: order, statusColors: statusColors, textComponent: textComponent, designImage: viewModel.designImage)
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .onAppear() {
                viewModel.fetchCustomOrder()
            }
            .onChange(of: currentTab) { oldValue, newValue in
                if oldValue != newValue {
                    dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}


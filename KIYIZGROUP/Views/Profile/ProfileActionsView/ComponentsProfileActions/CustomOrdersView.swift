//  CustomOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/1/25.

import SwiftUI

struct CustomOrdersView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ProfileVM
//    @StateObject private var statusColors = StatusColors()
    private let statusColors = StatusColors() 

    @State private var selectedOrder: CustomOrder?
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack {
            textComponent.createText(text: "Заказ", fontSize: 26, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            List(viewModel.orders) { order in
                OrderRow(order: order, colorScheme: colorScheme, statusColors: statusColors, textComponent: textComponent)
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .onAppear {
                Task {
                    await viewModel.fetchUserProfile()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}


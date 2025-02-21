//  DeliveryView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/1/25.

import SwiftUI

struct DeliveryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ProfileVM
    @State private var selectedOrder: Order?
    private let textComponent = TextComponent()
    private let statusColors = StatusColors()
    @Binding var currentTab: Int
    
    var body: some View {
        VStack {
            textComponent.createText(text: "Детали", fontSize: 26, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            List(viewModel.orders) { order in
                OrderRow(order: order, colorScheme: colorScheme, statusColors: statusColors, textComponent: textComponent)
                    .onTapGesture {
                        selectedOrder = order
                    }
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .onAppear {
                Task {
                    await viewModel.fetchUserProfile()
                }
            }
        }
        .sheet(item: $selectedOrder) { order in
            OrderItems(order: order)
                .presentationDetents([.height(300)])
        }
        .onChange(of: currentTab) { oldValue, newValue in
            if oldValue != newValue {
                dismiss()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}


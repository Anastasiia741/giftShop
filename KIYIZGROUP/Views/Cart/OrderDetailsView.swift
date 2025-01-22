//  OrderDetailsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct OrderDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = CartVM()
    @StateObject private var profileVM = ProfileVM()
    private let textComponent = TextComponent()
    let orderProducts: [Product]
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal, showsIndicators: false) {
                HeaderView(orderProducts: orderProducts, showEditButton: false)
                    .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                DetailView(viewModel: profileVM, order: order)
            }
            Spacer()
        }
        .navigationTitle("Доставки")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}



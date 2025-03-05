//  OrderDetailsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct OrderDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var profileVM = ProfileVM()
    private let textComponent = TextComponent()
    @Binding var currentTab: Int
    let orderProducts: [Product]
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DetailView(viewModel: profileVM, order: order)
            Spacer()
        }
        .onChange(of: currentTab) { _, _ in
            dismiss()
        }
        .onAppear{
            Task {
                await profileVM.fetchUserProfile()
            }
        }
        .navigationTitle("Доставка")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}



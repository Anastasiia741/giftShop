//  CustomDetailsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 6/2/25.

import SwiftUI

struct CustomDetailsView: View {
    @ObservedObject var viewModel: CustomProductVM
    @Environment(\.dismiss) private var dismiss
    let customOrder: CustomOrder
    @State private var designImage: UIImage? = nil
    @State private var addedImage: UIImage? = nil

    @Binding var currentTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                CustomBackButton()
                Spacer()
            }
            .padding([.leading, .top], 8)
           
            OrderDetailsSection(productType: viewModel.selectedProduct?.name ?? "Не выбран", comment: viewModel.comment, designImage: designImage, addedImage: addedImage)
            
            VStack(alignment: .leading, spacing: 16) {
                CustomDetailView(viewModel: viewModel, customOrder: customOrder)
            }
            Spacer()
                .padding(.top, 4)
        }
        .onChange(of: currentTab) { _, _ in
                dismiss()
        }
        .onAppear {
              Task {
                  addedImage = await viewModel.loadSelectedDesignImage()
                  designImage = await viewModel.loadStyleImage()
              }
          }
        .padding(.horizontal)
        .navigationTitle("Индивидуальный заказ")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

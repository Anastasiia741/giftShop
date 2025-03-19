//  CustomDetailsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 6/2/25.

import SwiftUI

struct CustomDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CustomProductVM
    let customOrder: CustomOrder
    @State private var designImage: UIImage? = nil
    @State private var addedImage: UIImage? = nil
    @Binding var currentTab: Int
    @Binding var isViewActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            OrderDetailsSection(productType: viewModel.selectedProduct?.name ?? "not_selected".localized, comment: viewModel.comment, designImage: designImage, addedImage: addedImage)
            
            VStack(alignment: .leading, spacing: 16) {
                CustomDetailView(viewModel: viewModel, customOrder: customOrder)
            }
            Spacer()
                .padding(.top, 4)
        }
        .onChange(of: currentTab) { _, _ in
            isViewActive = false
            dismiss()
        }
        .onAppear {
            Task {
                addedImage = await viewModel.loadSelectedDesignImage()
                designImage = await viewModel.loadStyleImage()
            }
        }
        .padding(.horizontal)
        .navigationTitle("custom_design".localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

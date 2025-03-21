//  ConfirmCustomOrderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 4/2/25.

import SwiftUI

struct CustomOrderView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CustomProductVM
    let customOrder: CustomOrder
    @State private var designImage: UIImage? = nil
    @State private var addedImage: UIImage? = nil
    @Binding var currentTab: Int
    @State var isLoading = false
    @State private var showCustomDetailsView = false
 
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 8)
                
                OrderDetailsSection(productType: viewModel.selectedProduct?.name ?? "not_selected".localized, comment: viewModel.comment, designImage: designImage, addedImage: addedImage)
                    .padding(.top, 4)
                
                ContactInfoSection(phoneNumber: $viewModel.phone)
                    .padding([.horizontal, .vertical])
                Spacer()
                
                GreenButton(text: "place_an_order".localized, isDisabled: viewModel.phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                    Task {
                        isLoading = true
                        await viewModel.saveCustomOrder()
                        isLoading = false
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
            
            if isLoading {
                Spacer()
                LoadingView()
                Spacer()
                
            }
            
            if viewModel.showInfoView {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                InfoView(isOpenView: $viewModel.showInfoView)
                    .transition(.opacity)
            }
        }
        .onTapGesture { self.hideKeyboard() }
        .onChange(of: currentTab) { _, _ in
            dismiss()
        }
        .navigationDestination(isPresented: $viewModel.showOrderDetails) {
            CustomDetailsView(viewModel: viewModel, customOrder: customOrder, currentTab: $currentTab, isViewActive: $viewModel.showOrderDetails)
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: viewModel.showInfoView)
        .navigationTitle("custom_order".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                addedImage = await viewModel.loadSelectedDesignImage()
                designImage = await viewModel.loadStyleImage()
            }
        }
    }
}

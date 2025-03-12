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
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 8)
                
                OrderDetailsSection(productType: viewModel.selectedProduct?.name ?? "Не выбран", comment: viewModel.comment, designImage: designImage, addedImage: addedImage)
                    .padding(.top, 4)
                
                ContactInfoSection(phoneNumber: $viewModel.phone)
                    .padding([.horizontal, .vertical])
                Spacer()
                
                GreenButton(text: "Оформить заказ", isDisabled: viewModel.phone.trimmingCharacters(in:   .whitespacesAndNewlines).isEmpty) {
                    Task {
                        isLoading = true
                        await viewModel.submitOrder()
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
        .onChange(of: currentTab) { _, _ in
            dismiss()
        }
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
        .navigationDestination(isPresented: $viewModel.showOrderDetails) {
            CustomDetailsView(viewModel: viewModel, customOrder: customOrder, currentTab: $currentTab)
        }
        .animation(.easeInOut, value: isLoading)
        .animation(.easeInOut, value: viewModel.showInfoView)
        .navigationTitle("Индивидуальный заказ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                addedImage = await viewModel.loadSelectedDesignImage()
                designImage = await viewModel.loadStyleImage()
            }
        }
    }
}

//  CustomView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CustomView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CustomProductVM()
    let customOrder: CustomOrder?
    private let textComponent = TextComponent()
    private let customButton = CustomButton()
    @State private var imageName: String = "Прикрепить фото"
    @State private var isShowGallery = false
    @State private var isShowCamera = false
    @State private var isShowPicker = false
    @Binding var currentTab: Int
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 16)
                Spacer()
                ProductTypeSection(viewModel: viewModel)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                DesignSelectionSection(viewModel: viewModel)
                    .padding(.horizontal, 16)
                
                ImagePickerButton(title: imageName) {
                    isShowPicker.toggle()
                }
                .padding(.horizontal, 16)
                AdditionalInfoSection(additionalText: $viewModel.comment)
                    .padding(.vertical)
                    .padding(.horizontal, 16)
                
                GreenButton(text: "Продолжить", isDisabled: viewModel.selectedProduct == nil && viewModel.selectedStyle == nil && viewModel.selectedImage == nil
                ) {
                    viewModel.isShowConfirm.toggle()
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .onChange(of: currentTab) { _, _ in
                dismiss()
            }
            .onTapGesture {
                self.hideKeyboard()
                UIApplication.shared.endEditing()
            }
            .navigationDestination(isPresented: $viewModel.isShowConfirm) {
                if let customOrder = customOrder {
                    CustomOrderView(viewModel: viewModel, customOrder: customOrder, currentTab: $currentTab)
                }
            }
        }
        
        .navigationTitle("Индивидуальный заказ")
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowPicker) {
            PhotoSourceSheetView(isShowGalleryPicker: $isShowGallery, isShowCameraPicker: $isShowCamera,
                                 onDismiss: {isShowPicker = false})
            .presentationDetents([.height(250)])
        }
        
        .sheet(isPresented: $isShowGallery) {
            ImagePicker(sourceType: .photoLibrary, onSelected: { image, name in
                viewModel.selectedImage = image
                imageName = name.map { String($0.prefix(20)) } ?? "Фото выбрано"
            },
                        selectedImage: $viewModel.selectedImage, isPresented: $isShowGallery)
        }
        
        .sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, onSelected: {image, name in
                viewModel.selectedImage = image
                imageName = name.map { String($0.prefix(20)) } ?? "Фото выбрано"
            },
                        selectedImage: $viewModel.selectedImage, isPresented: $isShowCamera)
        }
    }
}



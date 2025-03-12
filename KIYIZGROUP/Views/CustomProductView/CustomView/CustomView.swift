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
    @State private var showGallery = false
    @State private var showCamera = false
    @State private var showPicker = false
    @Binding var currentTab: Int
    @State private var showCustomOrderView = false

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
                    showPicker.toggle()
                }
                .padding(.horizontal, 16)
                AdditionalInfoSection(additionalText: $viewModel.comment)
                    .padding(.vertical)
                    .padding(.horizontal, 16)
                
                GreenButton(text: "Продолжить", isDisabled: viewModel.selectedProduct == nil && viewModel.selectedStyle == nil && viewModel.selectedImage == nil) {
                    viewModel.isShowConfirm.toggle()
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .onChange(of: currentTab) { _, _ in
                showCustomOrderView = false
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
        .onTapGesture {
            self.hideKeyboard()
        }
        .sheet(isPresented: $showPicker) {
            PhotoSourceSheetView(isShowGallery: $showGallery, isShowCamera: $showCamera,
                                 onDismiss: {showPicker = false})
            .presentationDetents([.height(250)])
        }
        
        .sheet(isPresented: $showGallery) {
            ImagePicker(sourceType: .photoLibrary, onSelected: { image, name in
                viewModel.selectedImage = image
                imageName = name.map { String($0.prefix(20)) } ?? "Фото выбрано"
            },
                        selectedImage: $viewModel.selectedImage, isPresented: $showGallery)
        }
        
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, onSelected: {image, name in
                viewModel.selectedImage = image
                imageName = name.map { String($0.prefix(20)) } ?? "Фото выбрано"
            },
                        selectedImage: $viewModel.selectedImage, isPresented: $showCamera)
        }
    }
}



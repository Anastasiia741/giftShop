//  CustomView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct CustomView: View {
    @StateObject private var viewModel = CustomProductVM()
    let customOrder: CustomOrder?
    private let customButton = CustomButton()
    @State private var imageName: String = "Прикрепить фото"
    @State private var isShowGallery = false
    @State private var isShowCamera = false
    @State private var isShowPicker = false
    
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
                    .padding(.horizontal, 20)
               
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }
                
                DesignSelectionSection(viewModel: viewModel)
                    .padding(.horizontal, 20)
                ImagePickerButton(title: imageName) {
                    isShowPicker.toggle()
                }
                .padding(.horizontal, 20)
                AdditionalInfoSection(additionalText: $viewModel.comment)
                    .padding(.vertical)
                    .padding(.horizontal, 20)
                
                GreenButton(text: "Продолжить",
                            isDisabled: viewModel.selectedProduct == nil && viewModel.selectedStyle == nil && viewModel.selectedImage == nil
                ) {
                    viewModel.isShowConfirm.toggle()
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $viewModel.isShowConfirm) {
                if let customOrder = customOrder {
                    CustomOrderView(viewModel: viewModel, customOrder: customOrder)
                } else {
                    Text("No order available")
                        .font(.headline)
                        .foregroundColor(.gray)
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
            ImagePicker(
                sourceType: .photoLibrary,
                onSelected: { image, name in
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
     
               

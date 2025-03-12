//  CreateProductView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct CreateProductView: View {
    @StateObject private var viewModel = CreateProductVM()
    @State private var showImgAlert = false
    @State private var showPicker = false
    @State private var showGallery = false
    @State private var showCamera = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text(Localization.image)) {
                    VStack {
                        Image(uiImage: (viewModel.productImage ?? Images.CreateProduct.image ?? UIImage()))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .validationBorder(isValid: viewModel.isImageValid)
                            .cornerRadius(10)
                            .onTapGesture {
                                showImgAlert = true
                            }
                    }
                }
                Section(header: Text(Localization.description)
                    )
                {
                    TextField(Localization.productName, text: $viewModel.name)
                        .validationBorder(isValid: viewModel.isNameValid)
                    TextField(Localization.category, text: $viewModel.category)
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                        .validationBorder(isValid: viewModel.isCategoryValid)
                    TextField(Localization.price, text: $viewModel.price)
                        .validationBorder(isValid: viewModel.isPriceValid)
                        .keyboardType(.decimalPad)
                    TextField("Цена до скидки", text: $viewModel.fullPrice)
                        .keyboardType(.decimalPad)
                        .validationBorder(isValid: viewModel.isFullPriceValid)
                }
                Section(header: Text(Localization.detailedProductDescrip)) {
                    TextEditor(text: $viewModel.detail)
                        .frame(height: 100)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
            }
            Button(Localization.save) {
                viewModel.createNewProduct()
            }
            .font(.system(size: 16))
            .frame(maxWidth: 150, minHeight: 50)
            .foregroundColor(.white)
            .background(.orange)
            .cornerRadius(20)
            .padding(.bottom)
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .onDisappear {
            viewModel.resetValidation()
        }
        .sheet(isPresented: $showImgAlert) {
            PhotoSourceSheetView(isShowGallery: $showGallery, isShowCamera: $showCamera, onDismiss: { showImgAlert = false })
                .presentationDetents([.height(250)])
        }
        .sheet(isPresented: $showGallery) {
            ImagePicker(sourceType: .photoLibrary, onSelected: { image, fileName in
                viewModel.productImage = image
            },
                        selectedImage: $viewModel.productImage,
                        isPresented: $showGallery)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, onSelected: { image, fileName in
                viewModel.productImage = image
            },
                        selectedImage: $viewModel.productImage,
                        isPresented: $showCamera)
        }
        
        .alert(item: $viewModel.alertModel) { alertModel in
            Alert(
                title: Text(alertModel.title ?? ""),
                message: Text(alertModel.message ?? ""),
                dismissButton: .default(Text(alertModel.buttons.first?.title ?? Localization.ok), action: {
                    alertModel.buttons.first?.action?()
                })
            )
        }
    }
}

extension View {
    func validationBorder(isValid: Bool) -> some View {
        self
            .padding(12)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid ? Color.gray.opacity(0.5) : Color.red, lineWidth: isValid ? 1 : 2)
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
    }
}


//  CreateProductView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct CreateProductView: View {
    @StateObject private var viewModel = CreateProductVM()
    @State private var selectedLanguageTab: LanguageTab = .ru
    @State private var showImgAlert = false
    @State private var showGallery = false
    @State private var showCamera = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Изображение")) {
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
                
                HStack {
                    ForEach(LanguageTab.allCases) { tab in
                        Button(action: {
                            withAnimation {
                                selectedLanguageTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(selectedLanguageTab == tab ? Color.orange : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Section(header: Text("Описание")) {
                    getTextFieldForSelectedLanguage()
                        .padding(.vertical, 5)
                }
                
                Section(header: Text("Цена")) {
                    TextField("Цена", text: $viewModel.price)
                        .validationBorder(isValid: viewModel.isPriceValid)
                        .keyboardType(.decimalPad)
                    TextField("Цена до скидки", text: $viewModel.fullPrice)
                        .keyboardType(.decimalPad)
                        .validationBorder(isValid: viewModel.isFullPriceValid)
                }
            }
            
            Button("сохранить") {
                viewModel.createNewProduct()
            }
            .font(.system(size: 16))
            .frame(maxWidth: 150, minHeight: 50)
            .foregroundColor(.white)
            .background(.orange)
            .cornerRadius(20)
            .padding(.bottom)
        }
        .onTapGesture { self.hideKeyboard() }
        .onDisappear { viewModel.resetValidation() }
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
                dismissButton: .default(Text(alertModel.buttons.first?.title ?? "ок"), action: {
                    alertModel.buttons.first?.action?()
                })
            )
        }
    }
}

extension CreateProductView {
    
    @ViewBuilder
    private func getTextFieldForSelectedLanguage() -> some View {
        switch selectedLanguageTab {
        case .ru:
            TextField("Название товара (РУ)", text: $viewModel.nameRu)
                .validationBorder(isValid: viewModel.isNameValid)
            TextField("Категория (РУ)", text: $viewModel.categoryRu)
                .keyboardType(.alphabet)
                .autocapitalization(.none)
                .validationBorder(isValid: viewModel.isCategoryValid)
            Text("Детали (РУ)").foregroundColor(.gray)
            TextEditor(text: $viewModel.detailRu)
                .frame(height: 100)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
        case .inl:
            TextField("Название товара (EN)", text: $viewModel.nameEn)
                .validationBorder(isValid: viewModel.isNameValid)
            TextField("Категория (EN)", text: $viewModel.categoryEn)
                .keyboardType(.alphabet)
                .autocapitalization(.none)
                .validationBorder(isValid: viewModel.isCategoryValid)
            Text("Детали (EN)").foregroundColor(.gray)
            TextEditor(text: $viewModel.detailEn)
                .frame(height: 100)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
        case .kyrg:
            TextField("Название товара (КЫРГ)", text: $viewModel.nameKg)
                .validationBorder(isValid: viewModel.isNameValid)
            TextField("Категория (КЫРГ)", text: $viewModel.categoryKg)
                .keyboardType(.alphabet)
                .autocapitalization(.none)
                .validationBorder(isValid: viewModel.isCategoryValid)
            Text("Детали (КЫРГ)").foregroundColor(.gray)
            TextEditor(text: $viewModel.detailKg)
                .frame(height: 100)
                .padding(.horizontal)
                .padding(.bottom, 5)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
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

//  ProductDetailEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Kingfisher
import SwiftUI

struct ProductEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLanguageTab: LanguageTab = .ru
    @ObservedObject var viewModel: ProductEditVM
    private let textComponent = TextComponent()
    @State private var selectedImage: UIImage?
    @State private var showImgAlert = false
    @State private var showGallery = false
    @State private var showCamera = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                imageSection
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
                .padding(.horizontal)
                getTextFieldsForLanguage(selectedLanguageTab)
                priceSection
                saveDeleteButtons
            }
        }
        .onTapGesture { self.hideKeyboard() }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .sheet(isPresented: $showImgAlert) {
            PhotoSourceSheetView(isShowGallery: $showGallery, isShowCamera: $showCamera, onDismiss: { showImgAlert = false })
                .presentationDetents([.height(250)])
        }
        .sheet(isPresented: $showGallery) {
            ImagePicker(sourceType: .photoLibrary, onSelected: { image, fileName in
                selectedImage = image
            },
                        selectedImage: $viewModel.selectedImage,
                        isPresented: $showGallery
            )
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, onSelected: { image, fileName in
                selectedImage = image
            },
                        selectedImage: $viewModel.selectedImage,
                        isPresented: $showCamera
            )
        }
        .alert(item: $viewModel.alertModel) { alertModel in
            if alertModel.buttons.count > 1 {
                return Alert(
                    title: Text(alertModel.title ?? ""),
                    message: Text(alertModel.message ?? ""),
                    primaryButton: .default(Text(alertModel.buttons.first?.title ?? ""), action: alertModel.buttons.first?.action),
                    secondaryButton: .default(Text(alertModel.buttons.last?.title ?? ""), action: alertModel.buttons.last?.action)
                )
            } else {
                return Alert(
                    title: Text(alertModel.title ?? ""),
                    message: Text(alertModel.message ?? ""),
                    dismissButton: .default(Text(alertModel.buttons.first?.title ?? ""), action: alertModel.buttons.first?.action)
                )
            }
        }
    }
}

extension ProductEditView {
    @ViewBuilder
    private func getTextFieldsForLanguage(_ language: LanguageTab) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            let langCode = getLanguageCode(language)
            
            textComponent.createText(text: "Название товара (\(language.rawValue))", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                .padding(.horizontal)
            
            TextField("Введите название", text: Binding(
                get: { viewModel.selectedProduct?.name[langCode] ?? "" },
                set: { viewModel.selectedProduct?.name[langCode] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            textComponent.createText(text: "Категория (\(language.rawValue))", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                .padding(.horizontal)
            
            TextField("Введите категорию", text: Binding(
                get: { viewModel.selectedProduct?.category[langCode] ?? "" },
                set: { viewModel.selectedProduct?.category[langCode] = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            textComponent.createText(text: "Описание (\(language.rawValue))", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                .padding(.horizontal)
            
            TextEditor(text: Binding(
                get: { viewModel.selectedProduct?.detail[langCode] ?? "" },
                set: { viewModel.selectedProduct?.detail[langCode] = $0 }
            ))
            .frame(height: 100)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            .padding(.horizontal)
        }
    }
    
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            textComponent.createText(text: "Цена", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                .padding(.horizontal)
            TextField("Введите цену", text: Binding(
                get: { String(viewModel.selectedProduct?.price ?? 0) },
                set: { viewModel.selectedProduct?.price = Int($0) ?? 0 }
            ))
            .keyboardType(.decimalPad)
            .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            textComponent.createText(text: "Цена до скидки", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                .padding(.horizontal)
            TextField("0", text: Binding(
                get: { String(viewModel.selectedProduct?.fullPrice ?? 0) },
                set: { viewModel.selectedProduct?.fullPrice = Int($0) ?? 0 }
            ))
            .keyboardType(.decimalPad)
            .padding(.horizontal)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var saveDeleteButtons: some View {
        HStack(spacing: 16) {
            Button("Удалить товар") {
                viewModel.showDeleteConfirmationAlert {
                    dismiss()
                }
            }
            .font(.system(size: 16))
            .fontWeight(.medium)
            .frame(maxWidth: 140, minHeight: 40)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(20)
            
            Spacer().frame(width: 16)
            
            Button("Сохранить") {
                viewModel.saveEditedProduct()
                viewModel.onSaveCompletion = { dismiss() }
            }
            .font(.system(size: 16))
            .fontWeight(.medium)
            .frame(maxWidth: 140, minHeight: 40)
            .foregroundColor(.white)
            .background(Color(StatusColor.greenButtom))
            .cornerRadius(20)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private var imageSection: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 260)
                    .clipped()
                    .border(Color.gray, width: 2)
                    .cornerRadius(10)
                    .onTapGesture { showImgAlert = true }
            } else {
                KFImage(viewModel.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 260)
                    .clipped()
                    .border(Color.gray, width: 2)
                    .cornerRadius(10)
                    .onAppear { viewModel.updateImageDetail() }
                    .onTapGesture { showImgAlert = true }
            }
        }
        .padding(.horizontal)
    }
    
    private func getLanguageCode(_ language: LanguageTab) -> String {
        switch language {
        case .ru: return "ru"
        case .inl: return "en"
        case .kyrg: return "ky"
        }
    }
}


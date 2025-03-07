//  CreateProductView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct CreateProductView: View {
    @Environment(\.colorScheme) private var colorScheme
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
                            .frame(maxWidth: .infinity, maxHeight: 260)
                            .clipped()
                            .border(Color.gray, width: 2)
                            .cornerRadius(10)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                showImgAlert = true
                            }
                    }
                }
                Section(header: Text(Localization.description).foregroundColor(colorScheme == .dark ? .white : .black)) {
                    TextField(Localization.productName, text: $viewModel.name)
                    TextField(Localization.category, text: $viewModel.category)
                        .keyboardType(.alphabet)
                        .autocapitalization(.none)
                    TextField(Localization.price, text: $viewModel.price)
                        .keyboardType(.decimalPad)
                    TextField("Цена до скидки", text: $viewModel.fullPrice)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text(Localization.detailedProductDescrip).foregroundColor(colorScheme == .dark ? .white : .black)) {
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
            .fontWeight(.medium)
            .frame(maxWidth: 100, minHeight: 40)
            .foregroundColor(.white)
            .background(Color(.orange))
            .cornerRadius(20)
            .shadow(color: Color(.orange).opacity(0.5), radius: 5, x: 0, y: 5)
            .padding(.bottom)
        }
        .onTapGesture {
            self.hideKeyboard()
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
    }
}

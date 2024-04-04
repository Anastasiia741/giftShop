//  CreateProductView.swift
//  GiftShop
//  Created by Анастасия Набатова on 11/1/24.

import SwiftUI

struct CreateProductView: View {
    
    @StateObject private var viewModel = CreateProductVM()
    @State private var showImgAlert = false
    @State private var isShowingGalleryPicker = false
    @State private var isShowingCameraPicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text(Localization.image).foregroundColor(.black)) {
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
                    Section(header: Text(Localization.description).foregroundColor(.black)) {
                        TextField(Localization.productName, text: $viewModel.productName)
                        TextField(Localization.category, text: $viewModel.productCategory)
                            .keyboardType(.alphabet)
                            .autocapitalization(.none)
                        TextField(Localization.price, text: $viewModel.productPrice)
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text(Localization.detailedProductDescrip).foregroundColor(.black)) {
                        TextEditor(text: $viewModel.productDetail)
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
            .confirmationDialog(Localization.selectPhotoSource, isPresented: $showImgAlert) {
                Button(Localization.gallery) {
                    isShowingGalleryPicker = true
                }
                Button(Localization.camera) {
                    isShowingCameraPicker = true
                }
            }
            .sheet(isPresented: $isShowingGalleryPicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.productImage, isPresented: $isShowingGalleryPicker)
            }
            .sheet(isPresented: $isShowingCameraPicker) {
                ImagePicker(sourceType: .camera, selectedImage: $viewModel.productImage, isPresented: $isShowingGalleryPicker)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text(Localization.ok))
                )
            }
        }
    }
}

struct CreateProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProductView()
    }
}

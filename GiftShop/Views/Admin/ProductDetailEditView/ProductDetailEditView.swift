//  ProductDetailEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import SDWebImageSwiftUI
import SwiftUI

struct ProductDetailEditView: View {
    
    @StateObject var viewModel: ProductDetailEditVM
    @State private var selectedImage: UIImage?
    @State private var isShowingGalleryPicker = false
    @State private var isShowingCameraPicker = false
    @State private var showImgAlert = false
    @State private var showDeleteAlert = false
    @State private var showSaveAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                WebImage(url: viewModel.imageURL )
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 260)
                    .clipped()
                    .border(Color.gray, width: 2)
                    .cornerRadius(10)
                    .padding(.vertical, 8)
                    .onAppear {
                        viewModel.updateImageDetail()
                    }
                    .onTapGesture {
                        showImgAlert = true
                    }
            }
            .padding([.leading, .trailing], 20)
            VStack(alignment: .leading, spacing: 8) {
                Text("product_name".localized).font(.callout)
                TextField("enter_product_name".localized, text: $viewModel.selectedProduct.name)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("category".localized).font(.callout)
                TextField("enter_category".localized, text: $viewModel.selectedProduct.category)
                    .keyboardType(.alphabet)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("price".localized).font(.callout)
                TextField("enter_price".localized, text: Binding(
                    get: { String(viewModel.selectedProduct.price) },
                    set: { viewModel.selectedProduct.price = Int($0) ?? 0 }))
                .keyboardType(.decimalPad)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("detailed_product_descrip".localized).font(.callout)
                TextEditor(text: $viewModel.selectedProduct.detail)
                    .frame(height: 100)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }.padding([.leading, .trailing], 20)
            HStack(spacing: 16){
                Button("delete".localized) {
                    showDeleteAlert = true
                }
                .font(.system(size: 16))
                .fontWeight(.medium)
                .frame(maxWidth: 120, minHeight: 40)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(20)
                .shadow(color: Color.red.opacity(0.5), radius: 5, x: 0, y: 5)
                .alert(isPresented: $showDeleteAlert) {
                    Alert(title: Text("delete_product".localized), primaryButton: .cancel(Text("yes".localized)) {
                        Task {
                            await viewModel.deleteProduct()
                        }
                    }, secondaryButton: .destructive(Text("no".localized)))
                }
                Spacer().frame(width: 16)
                Button("save".localized) {
                    Task {
                        await viewModel.saveEditedProduct()
                    }
                }
                .font(.system(size: 16))
                .fontWeight(.medium)
                .frame(maxWidth: 120, minHeight: 40)
                .foregroundColor(.white)
                .background(Color(.green))
                .cornerRadius(20)
                .shadow(color: Color(.green).opacity(0.5), radius: 5, x: 0, y: 5)
                .alert(isPresented: $showSaveAlert) {
                    Alert(title: Text("data_saved_successfully".localized), dismissButton: .default(Text("ok".localized)))
                }
            }
            .padding(.bottom)
            
        }
        .confirmationDialog("select_photo_source".localized, isPresented: $showImgAlert) {
            Button("gallery".localized) {
                isShowingGalleryPicker = true
            }
            Button("camera".localized) {
                isShowingCameraPicker = true
            }
        }
        .onAppear {
        }
        .sheet(isPresented: $isShowingGalleryPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
        }
        .sheet(isPresented: $isShowingCameraPicker) {
            ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
        }
    }
}



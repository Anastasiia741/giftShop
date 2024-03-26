//  ProductDetailEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import SDWebImageSwiftUI
import SwiftUI

struct ProductDetailEditView: View {
    
    @ObservedObject var viewModel: ProductDetailEditVM
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedImage: UIImage?
    @State private var isShowingGalleryPicker = false
    @State private var isShowingCameraPicker = false
    @State private var showImgAlert = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                WebImage(url: viewModel.imageURL)
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
                Text(Localization.productName).font(.callout)
                TextField(Localization.enterProductName, text: Binding(
                    get: { viewModel.selectedProduct?.name ?? "" },
                    set: { newValue in
                        viewModel.selectedProduct?.name = newValue
                    }
                ))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text(Localization.category).font(.callout)
                TextField(Localization.enterCategory, text: Binding(
                    get: { viewModel.selectedProduct?.category ?? "" },
                    set: { newValue in
                        viewModel.selectedProduct?.category = newValue
                    }
                ))
                .keyboardType(.alphabet)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text(Localization.price).font(.callout)
                TextField(Localization.enterPrice, text: Binding(
                    get: { String(viewModel.selectedProduct?.price ?? 0) },
                    set: { viewModel.selectedProduct?.price = Int($0) ?? 0 }))
                .keyboardType(.decimalPad)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text(Localization.detailedProductDescrip).font(.callout)
                TextEditor(text: Binding(
                    get: { viewModel.selectedProduct?.detail ?? "" },
                    set: { newValue in
                        viewModel.selectedProduct?.detail = newValue
                    }
                ))
                .frame(height: 100)
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }.padding([.leading, .trailing], 20)
            HStack(spacing: 16){
                Button(Localization.delete) {
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
                    Alert(title: Text(Localization.deleteProduct), primaryButton: .cancel(Text(Localization.yes)) {
                        viewModel.deleteProduct()
                    }, secondaryButton: .destructive(Text(Localization.no)))
                }
                Spacer().frame(width: 16)
                Button(Localization.save) {
                    viewModel.saveEditedProduct()
                }
                .font(.system(size: 16))
                .fontWeight(.medium)
                .frame(maxWidth: 120, minHeight: 40)
                .foregroundColor(.white)
                .background(Color(.green))
                .cornerRadius(20)
                .shadow(color: Color(.green).opacity(0.5), radius: 5, x: 0, y: 5)
            }
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
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
        }
        .sheet(isPresented: $isShowingCameraPicker) {
            ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(""),
                dismissButton: .default(Text(Localization.ok)){
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}



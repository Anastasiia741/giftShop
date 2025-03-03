//  ProductDetailEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Kingfisher
import SwiftUI

struct ProductDetailEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: ProductDetailEditVM
    @State private var selectedImage: UIImage?
    @State private var isShowingGalleryPicker = false
    @State private var isShowingCameraPicker = false
    @State private var showImgAlert = false
    
    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                VStack(alignment: .leading) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 260)
                            .clipped()
                            .border(Color.gray, width: 2)
                            .cornerRadius(10)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showImgAlert = true
                            }
                    } else {
                        KFImage(viewModel.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 260)
                            .clipped()
                            .border(Color.gray, width: 2)
                            .cornerRadius(10)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onAppear {
                                viewModel.updateImageDetail()
                            }
                            .onTapGesture {
                                showImgAlert = true
                            }
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
                    .autocapitalization(.none)
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
                        viewModel.showDeleteConfirmationAlert {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .frame(maxWidth: 120, minHeight: 40)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(20)
                    .shadow(color: Color.red.opacity(0.5), radius: 5, x: 0, y: 5)
                    Spacer().frame(width: 16)
                    Button(Localization.save) {
                        viewModel.saveEditedProduct()
                        viewModel.onSaveCompletion = {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .frame(maxWidth: 120, minHeight: 40)
                    .foregroundColor(.white)
                    .background(Color(StatusColor.greenButtom))
                    .cornerRadius(20)
                    .shadow(color: Color(.green).opacity(0.5), radius: 5, x: 0, y: 5)
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .confirmationDialog(Localization.selectPhotoSource, isPresented: $showImgAlert) {
            Button(Localization.gallery) {
                isShowingGalleryPicker = true
            }
            Button(Localization.camera) {
                isShowingCameraPicker = true
            }
        }
//        .sheet(isPresented: $isShowingGalleryPicker) {
//            ImagePicker(sourceType: .photoLibrary, onSelected: {selectedImage = viewModel.selectedImage}, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
//        }
//        .sheet(isPresented: $isShowingCameraPicker) {
//            ImagePicker(sourceType: .camera, onSelected: {selectedImage = viewModel.selectedImage }, selectedImage: $viewModel.selectedImage, isPresented: $isShowingCameraPicker)
//        }
//        
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




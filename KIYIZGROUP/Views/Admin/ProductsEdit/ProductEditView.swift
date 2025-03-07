//  ProductDetailEditView.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Kingfisher
import SwiftUI

struct ProductEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: ProductEditVM
    private let textComponent = TextComponent()
    @State private var selectedImage: UIImage?
    @State private var showPicker = false
    @State private var showGallery = false
    @State private var showCamera = false
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
                    textComponent.createText(text: Localization.productName, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    
                    TextField(Localization.enterProductName, text: Binding(
                        get: { viewModel.selectedProduct?.name ?? "" },
                        set: { newValue in
                            viewModel.selectedProduct?.name = newValue
                        }
                    ))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    textComponent.createText(text: Localization.category, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    
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
                    
                    textComponent.createText(text: Localization.price, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    
                    TextField(Localization.enterPrice, text: Binding(
                        get: { String(viewModel.selectedProduct?.price ?? 0) },
                        set: { viewModel.selectedProduct?.price = Int($0) ?? 0 }))
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    textComponent.createText(text: "Цена до скидки", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    
                    TextField("0", text: Binding(
                        get: { String(viewModel.selectedProduct?.fullPrice ?? 0) },
                        set: { viewModel.selectedProduct?.fullPrice = Int($0) ?? 0 }))
                    .keyboardType(.decimalPad)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    textComponent.createText(text: Localization.detailedProductDescrip, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    
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




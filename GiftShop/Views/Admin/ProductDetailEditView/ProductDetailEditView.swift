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
                Text("Название товара").font(.callout)
                TextField("Введите название товара", text: $viewModel.selectedProduct.name)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("Категория").font(.callout)
                TextField("Введите категорию", text: $viewModel.selectedProduct.category)
                    .keyboardType(.alphabet)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("Цена").font(.callout)
                TextField("Введите цену", text: Binding(
                    get: { String(viewModel.selectedProduct.price) },
                    set: { viewModel.selectedProduct.price = Int($0) ?? 0 }))
                .keyboardType(.decimalPad)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Text("Подробное описание товара").font(.callout)
                TextEditor(text: $viewModel.selectedProduct.detail)
                    .frame(height: 100)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }.padding([.leading, .trailing], 20)
            HStack(spacing: 16){
                Button("Удалить") {
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
                    Alert(title: Text("Удалить товар?"), primaryButton: .cancel(Text("Да")) {
                        Task {
                            await viewModel.deleteProduct()
                        }
                    }, secondaryButton: .destructive(Text("Нет")))
                }
                Spacer().frame(width: 16)
                Button("Сохранить") {
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
                .shadow(color: Color(.orange).opacity(0.5), radius: 5, x: 0, y: 5)
                .alert(isPresented: $showSaveAlert) {
                    Alert(title: Text("Данные успешно сохранены"), dismissButton: .default(Text("Ок")))
                }
            }
            .padding(.bottom)
            
        }
        .confirmationDialog("Выберите источник фото", isPresented: $showImgAlert) {
            Button("Галерея") {
                isShowingGalleryPicker = true
            }
            Button("Камера") {
                isShowingCameraPicker = true
            }
        }
        .onAppear {
            //            viewModel.loadImage(from: viewModel.imageURL)
        }
        .sheet(isPresented: $isShowingGalleryPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
        }
        .sheet(isPresented: $isShowingCameraPicker) {
            ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage, isPresented: $isShowingGalleryPicker)
        }
        
        
    }
}



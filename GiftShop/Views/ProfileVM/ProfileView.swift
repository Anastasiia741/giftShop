//  ProfileView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileVM()
    
    @State private var orders: [Order] = []
    @State private var selectedImage: UIImage?
    @State private var isAlertPresented = false
    
    @State private var isShowingCameraPicker = false
    @State private var isShowingGalleryPicker = false
    
    @State private var isQuitAlertPresenter = false
    @State private var isRemoveAlertPresenter = false
    @State private var isAuthViewPresenter = false
    @State private var isAccountDeletedAlert = false
    
    @State private var isProfileSavedAlert = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 18) {
                HStack(spacing: 12) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .onTapGesture {
                                isAlertPresented = true
                            }
                    } else {
                        Images.Profile.icon
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .onTapGesture {
                                isAlertPresented = true
                            }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ваше имя")
                            .padding(.leading, 20)
                            .font(.custom(TextStyle.avenirBold, size: 18))
                        
                        TextField("Введите имя", text: $viewModel.name)
                            .font(.custom(TextStyle.avenirBold, size: 16))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Введите номер телефона", text: $viewModel.phoneNumber)
                            .keyboardType(.numberPad)
                            .font(.custom(TextStyle.avenirRegular, size: 16))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                .confirmationDialog("Выберите источник фото", isPresented: $isAlertPresented) {
                    Button("Галерея") {
                        isShowingGalleryPicker = true
                    }
                    Button("Камера") {
                        isShowingCameraPicker = true
                    }
                }
                .onAppear {
                    viewModel.loadImage(from: viewModel.imageURL)
                }
                .sheet(isPresented: $isShowingGalleryPicker) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage, isPresented: $isShowingGalleryPicker)
                }
                .sheet(isPresented: $isShowingCameraPicker) {
                    ImagePicker(sourceType: .camera, selectedImage: $selectedImage, isPresented: $isShowingGalleryPicker)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Адрес доставки")
                        .padding(.leading, 20)
                        .font(.custom(TextStyle.avenirBold, size: 16))
                    TextField("Ваш адрес доставки", text: $viewModel.address)
                        .font(.custom(TextStyle.avenirRegular, size: 16))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    Spacer()
                    Button {
                        Task {
                            await viewModel.saveProfile()
                            if let selectedImage = selectedImage {
                                viewModel.image = selectedImage
                                await viewModel.saveProfileImage()
                            }
                            isProfileSavedAlert.toggle()
                        }
                    } label: {
                        Text("Сохранить")
                            .customTextStyle(TextStyle.avenirRegular, size: 12)
                            .frame(width: 100, height: 25)
                            .background(Colors.promo)
                            .cornerRadius(20)
                            .shadow(color: Colors.promo.opacity(0.5), radius: 5, x: 0, y: 5)
                            .foregroundColor(.white)
                            .padding(.trailing, 15)
                    }
                }  .onAppear {
                    Task {
                        await viewModel.fetchUserProfile()
                    }
                }
                //MARK: - Orders
                if viewModel.orders.isEmpty {
                    Spacer()
                    VStack(alignment: .center, spacing: 16) {
                        Text("Ваши заказы будут тут")
                            .customTextStyle(TextStyle.avenirBold, size: 16)
                        Images.Profile.emptyList
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                        Text("Заказов пока нет")
                            .customTextStyle(TextStyle.avenirBold, size: 16)
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text("Ваши заказы").customTextStyle(TextStyle.avenirBold, size: 16)) {
                            ForEach(viewModel.orders, id: \.id) { order in
                                ProfileCell(order: order, viewModel: ProfileVM.shared)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                //MARK: - Delete account
                HStack(alignment: .center) {
                    Button{
                        isRemoveAlertPresenter.toggle()
                    } label: {
                        Text("Удалить аккаунт")
                            .font(.system(size: 12))
                            .padding()
                            .padding(.horizontal, 20)
                            .frame(height: 20)
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                    .alert(isPresented: $isRemoveAlertPresenter) {
                        Alert(
                            title: Text("Удалить аккаунт?"),
                            primaryButton: .destructive(Text("Да")) {
                                viewModel.deleteAccount()
                                viewModel.logout()
                                isAuthViewPresenter = true
                            },
                            secondaryButton: .cancel(Text("Нет"))
                        )
                    }
                }
            }
            .padding()
            .alert(isPresented: $isProfileSavedAlert) {
                Alert(title: Text("Ваши данные успешно сохранены"), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                viewModel.fetchOrderHistory()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: HStack(spacing: 20) {
                    Button(action: {
                        isQuitAlertPresenter.toggle()
                        viewModel.logout()
                    }) {
                        Images.Profile.exit
                            .imageScale(.small)
                            .foregroundColor(.black)
                    }
                }
            )
            //MARK: - Logout
            .confirmationDialog("Хотите выйти?", isPresented: $isQuitAlertPresenter) {
                Button {
                    isAuthViewPresenter.toggle()
                } label: {
                    Text("Выйти")
                }
                Button(role: .cancel) {
                    print("Отмена")
                } label: {
                    Text("Отмена")
                }
            }
            .fullScreenCover(isPresented: $isAuthViewPresenter, onDismiss: nil) {
                AuthView()
            }
        }
    }
}

struct ProfileCell_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

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
                        Text("your_name".localized)
                            .padding(.leading, 20)
                            .font(.custom(TextStyle.avenirBold, size: 18))
                        
                        TextField("enter_your_name".localized, text: $viewModel.name)
                            .font(.custom(TextStyle.avenirBold, size: 16))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("enter_phone_number".localized, text: $viewModel.phoneNumber)
                            .keyboardType(.numberPad)
                            .font(.custom(TextStyle.avenirRegular, size: 16))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                .confirmationDialog("select_photo_source".localized, isPresented: $isAlertPresented) {
                    Button("gallery".localized) {
                        isShowingGalleryPicker = true
                    }
                    Button("camera".localized) {
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
                    Text("delivery_address".localized)
                        .padding(.leading, 20)
                        .font(.custom(TextStyle.avenirBold, size: 16))
                    TextField("your_delivery_address".localized, text: $viewModel.address)
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
                        Text("save".localized)
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
                        Text("your_orders".localized)
                            .customTextStyle(TextStyle.avenirBold, size: 16)
                        Images.Profile.emptyList
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                        Text("no_orders_yet".localized)
                            .customTextStyle(TextStyle.avenirBold, size: 16)
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text("your_orders".localized).customTextStyle(TextStyle.avenirBold, size: 16)) {
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
                        Text("delete_account".localized)
                            .font(.system(size: 12))
                            .padding()
                            .padding(.horizontal, 20)
                            .frame(height: 20)
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                    .alert(isPresented: $isRemoveAlertPresenter) {
                        Alert(
                            title: Text("delete_account?".localized),
                            primaryButton: .destructive(Text("yes".localized)) {
                                viewModel.deleteAccount()
                                viewModel.logout()
                                isAuthViewPresenter = true
                            },
                            secondaryButton: .cancel(Text("no".localized))
                        )
                    }
                }
            }
            .padding()
            .alert(isPresented: $isProfileSavedAlert) {
                Alert(title: Text("data_successfully_saved".localized), dismissButton: .default(Text("ok".localized)))
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
            .confirmationDialog("log_out?".localized, isPresented: $isQuitAlertPresenter) {
                Button {
                    isAuthViewPresenter.toggle()
                } label: {
                    Text("go_out".localized)
                }
                Button(role: .cancel) {
                } label: {
                    Text("cancel".localized)
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

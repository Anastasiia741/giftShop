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
                        Text(Localization.yourName)
                            .padding(.leading, 20)
                            .font(.custom(TextStyle.avenirBold, size: 18))
                        
                        TextField(Localization.enterYourName, text: $viewModel.name)
                            .font(.custom(TextStyle.avenirBold, size: 16))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField(Localization.enterPhoneNumber, text: $viewModel.phoneNumber)
                            .keyboardType(.numberPad)
                            .font(.custom(TextStyle.avenirRegular, size: 16))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                .confirmationDialog(Localization.selectPhotoSource, isPresented: $isAlertPresented) {
                    Button(Localization.gallery) {
                        isShowingGalleryPicker = true
                    }
                    Button(Localization.camera) {
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
                    Text(Localization.yourDeliveryAddress)
                        .padding(.leading, 20)
                        .font(.custom(TextStyle.avenirBold, size: 16))
                    TextField(Localization.enterYourDeliveryAddress, text: $viewModel.address)
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
                        Text(Localization.save)
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
                if viewModel.orders.isEmpty {
                    Spacer()
                    VStack(alignment: .center, spacing: 16) {
                        Text(Localization.yourOrders)
                            .customTextStyle(TextStyle.avenirBold, size: 16)
                        Images.Profile.emptyList
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                        Text(Localization.noOrdersYet)
                            .customTextStyle(TextStyle.avenirBold, size: 16)
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text(Localization.yourOrders).customTextStyle(TextStyle.avenirBold, size: 16)) {
                            ForEach(viewModel.orders, id: \.id) { order in
                                ProfileCell(order: order, viewModel: viewModel)
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
                        Text(Localization.deleteAccountName)
                            .font(.system(size: 12))
                            .padding()
                            .padding(.horizontal, 20)
                            .frame(height: 20)
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                    .alert(isPresented: $isRemoveAlertPresenter) {
                        Alert(
                            title: Text(Localization.deleteAccount),
                            primaryButton: .destructive(Text(Localization.yes)) {
                                viewModel.deleteAccount()
                                viewModel.logout()
                                isAuthViewPresenter = true
                            },
                            secondaryButton: .cancel(Text(Localization.no))
                        )
                    }
                }
            }
            .padding()
            .alert(isPresented: $isProfileSavedAlert) {
                Alert(title: Text(Localization.dataSuccessfullySaved), dismissButton: .default(Text(Localization.ok)))
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
            .actionSheet(isPresented: $isQuitAlertPresenter) {
                ActionSheet(
                    title: Text(Localization.logOut),
                    buttons: [
                        .default(Text(Localization.yes)) {
                            isAuthViewPresenter.toggle()
                            viewModel.logout()
                        },
                        .cancel(Text(Localization.cancel))
                    ]
                )
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

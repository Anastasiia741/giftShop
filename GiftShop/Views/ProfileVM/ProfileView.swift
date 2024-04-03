//  ProfileView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileVM()
    @Environment(\.presentationMode) private var presentationMode
    @State private var orders: [Order] = []
    @State private var selectedImage: UIImage?
    @State private var isImgAlertPresented = false
    @State private var isShowingCameraPicker = false
    @State private var isShowingGalleryPicker = false
    @State private var isQuitAlertPresenter = false
    @State private var isAuthViewPresenter = false
    @State private var isAccountDeletedAlert = false
    @State private var isNavigateToCatalog = false
    @State private var alertType: AlertType? = nil
    
    
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
                                isImgAlertPresented = true
                            }
                    } else {
                        Images.Profile.icon
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                            .onTapGesture {
                                isImgAlertPresented = true
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
                .confirmationDialog(Localization.selectPhotoSource, isPresented: $isImgAlertPresented) {
                    Button(Localization.gallery) {
                        isShowingGalleryPicker = true
                    }
                    Button(Localization.camera) {
                        isShowingCameraPicker = true
                    }
                }
                //TASK: - loadImage
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
                    Text(Localization.yourEmail)
                        .padding(.leading, 20)
                        .font(.custom(TextStyle.avenirBold, size: 16))
                    Text(viewModel.email)
                        .padding(.leading, 20)
                        .font(.custom(TextStyle.avenirRegular, size: 16))
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
                            viewModel.showAlert.toggle()
                            alertType = .save
                        }
                    } label: {
                        Text(Localization.save)
                            .customTextStyle(TextStyle.avenirBold, size: 14)
                            .frame(width: 100, height: 30)
                            .background(Colors.promo)
                            .cornerRadius(20)
                            .shadow(color: Colors.promo.opacity(0.5), radius: 5, x: 0, y: 5)
                            .foregroundColor(.white)
                            .padding(.trailing, 15)
                    }
                }.onAppear {
                    Task {
                        await viewModel.fetchUserProfile()
                        viewModel.fetchOrderHistory()
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
                HStack(alignment: .center) {
                    Button{
                        viewModel.showAlert.toggle()
                        alertType = .delete
                    } label: {
                        Text(Localization.deleteAccountName)
                            .font(.system(size: 12))
                            .padding()
                            .padding(.horizontal, 20)
                            .frame(height: 20)
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                    .alert(item: $alertType) { alertType in
                        switch alertType {
                        case .delete:
                            return Alert(title: Text(Localization.attention),
                                         message: Text(Localization.deleteYourAccount),
                                         primaryButton: .default(Text(Localization.yes)) {
                                viewModel.deleteAccount()
                                viewModel.logout()
                                isNavigateToCatalog = true
                            },
                                         secondaryButton: .cancel(Text(Localization.no))
                            )
                        case .save:
                            return Alert(title: Text(viewModel.alertTitle),
                                         dismissButton: .default(Text(Localization.ok)) {
                            })
                        }
                    }
                    .fullScreenCover(isPresented: $isNavigateToCatalog) {
                        TabBar(viewModel: MainTabViewModel())
                    }
                }
            }
            .padding()
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

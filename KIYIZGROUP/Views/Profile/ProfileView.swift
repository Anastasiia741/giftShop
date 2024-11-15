//  ProfileView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = ProfileVM()
    @State private var selectedImage: UIImage?
    @State private var isQuitAlertPresenter = false
    @State private var isAccountDeletedAlert = false
    @State private var keyboardOffset: CGFloat = 0
    
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(Localization.yourName)
                        .font(.custom(TextStyle.avenirBold, size: 18))
                    TextField(Localization.enterYourName, text: $viewModel.name)
                        .font(.custom(TextStyle.avenirRegular, size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField(Localization.enterPhoneNumber, text: $viewModel.phoneNumber)
                        .keyboardType(.numberPad)
                        .font(.custom(TextStyle.avenirRegular, size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(Localization.yourEmail)
                        .font(.custom(TextStyle.avenirBold, size: 16))
                    Text(viewModel.email)
                        .font(.custom(TextStyle.avenirRegular, size: 16))
                    Text(Localization.yourDeliveryAddress)
                        .font(.custom(TextStyle.avenirBold, size: 16))
                    TextField(Localization.enterYourDeliveryAddress, text: $viewModel.address)
                        .font(.custom(TextStyle.avenirRegular, size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Spacer()
                    Button {
                        Task {
                            await viewModel.saveProfile()
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
                }
                .onAppear {
                    Task {
                        await viewModel.fetchUserProfile()
                        viewModel.fetchOrderHistory()
                    }
                }
                VStack(alignment: .leading, spacing: 18) {
                    Text(Localization.yourOrders).customTextStyle(TextStyle.avenirBold, size: 16)
                    
                    if viewModel.orders.isEmpty {
                        Spacer()
                        VStack(alignment: .center, spacing: 18) {
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
                            Section(header: EmptyView() ) {
                                ForEach(viewModel.orders, id: \.id) { order in
                                    ProfileCell(order: order, viewModel: viewModel)
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                HStack(alignment: .center) {
                    Button{
                        viewModel.showDeleteConfirmationAlert {
                            viewModel.logout()
                        }
                    } label: {
                        Text(Localization.deleteAccountName)
                            .font(.system(size: 12))
                            .padding()
                            .padding(.horizontal, 20)
                            .frame(height: 20)
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
            .offset(y: -keyboardOffset)
            .navigationBarItems(leading: HStack {
                Text(Localization.profile)
                    .font(.title3.bold())
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .padding(.leading, 20)
                    .fixedSize()
                Image(uiImage: UIImage(named: colorScheme == .dark ? Images.Menu.popular2 : Images.Menu.popular1) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
            })
            .navigationBarItems(
                trailing: HStack(spacing: 20) {
                    Button(action: {
                        isQuitAlertPresenter.toggle()
                    }) {
                        Images.Profile.exit
                            .imageScale(.small)
                            .tint(colorScheme == .dark ? .white : .black)
                    }
                }
            )
            .actionSheet(isPresented: $isQuitAlertPresenter) {
                ActionSheet(
                    title: Text(Localization.logOut),
                    buttons: [
                        .default(Text(Localization.yes)) {
                            viewModel.logout()
                        },
                        .cancel(Text(Localization.cancel))
                    ]
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
            .fullScreenCover(isPresented: $viewModel.showQuitPresenter) {
                NavigationView {
                    TabBar(viewModel: MainTabVM())
                }
            }
            
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}



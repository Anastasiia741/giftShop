//  ProfileView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = ProfileVM()
    private let buttonComponents = ButtonComponents()
    private let textComponent = TextComponent()
    @State private var selectedImage: UIImage?
    @State private var isShowEditProfileView = false
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ProfileHeaderView(viewModel: viewModel)
                    
                    ProfileActionsView()
                    
                    ProfileInfoView()
                    
                    SupportInfoView()
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .topLeading) 
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: HStack(spacing: 20) {
                    Button(action: {
                        isShowEditProfileView.toggle()
                    }) {
                        Image("lucide")
                            .resizable()
                            .imageScale(.small)
                    }
                }
            )
            .navigationDestination(isPresented: $isShowEditProfileView) {
                EditProfileView(viewModel: viewModel)
            }
            
            .onAppear {
                Task {
                    await viewModel.fetchUserProfile()
                }
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            .scrollIndicators(.hidden) 
        }
    }
}











//VStack(alignment: .leading, spacing: 18) {
//    Text(Localization.yourOrders).customTextStyle(TextStyle.avenirBold, size: 16)
//    
//    if viewModel.orders.isEmpty {
//        Spacer()
//        VStack(alignment: .center, spacing: 18) {
//            Text(Localization.yourOrders)
//                .customTextStyle(TextStyle.avenirBold, size: 16)
//            Images.Profile.emptyList
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(height: 150)
//            Text(Localization.noOrdersYet)
//                .customTextStyle(TextStyle.avenirBold, size: 16)
//            Spacer()
//        }
//    } else {
//        List {
//            Section(header: EmptyView() ) {
//                ForEach(viewModel.orders, id: \.id) { order in
//                    ProfileCell(order: order, viewModel: viewModel)
//                }
//            }
//            .listStyle(.plain)
//        }
//    }
//}
//HStack(alignment: .center) {
//    Button{
//        viewModel.showDeleteConfirmationAlert {
//            viewModel.logout()
//        }
//    } label: {
//        Text(Localization.deleteAccountName)
//            .font(.system(size: 12))
//            .padding()
//            .padding(.horizontal, 20)
//            .frame(height: 20)
//            .foregroundColor(.gray)
//            .cornerRadius(20)
//    }
//}

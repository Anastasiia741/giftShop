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


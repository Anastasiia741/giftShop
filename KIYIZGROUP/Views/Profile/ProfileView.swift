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
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        ProfileHeaderView(viewModel: viewModel)
                        ProfileActionsView()
                        ProfileInfoView()
                        SupportInfoView()
                    }
                    .padding(.top, 70)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        isShowEditProfileView.toggle()
                    }) {
                        Image("lucide")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Color.white.opacity(0.9)
                        .edgesIgnoringSafeArea(.top)
                )
            }
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

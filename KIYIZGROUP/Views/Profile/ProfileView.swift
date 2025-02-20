//  ProfileView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var mainTabVM: MainTabVM
    @StateObject private var viewModel = ProfileVM()
    private let buttonComponents = ButtonComponents()
    private let textComponent = TextComponent()
    @State private var selectedImage: UIImage?
    @State private var isShowEditProfileView = false
    @State private var activeScreen: ProfileNavigation? = nil
    
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
                        withAnimation {
                            activeScreen = .editProfile
                        }
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
            .navigationDestination(item: $activeScreen) { screen in
                switch screen {
                case .editProfile:
                    EditProfileView(viewModel: viewModel, navigationTarget: $activeScreen)
                case .changePassword:
                    ChangePasswordView(activeScreen: $activeScreen)
                }
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


//  ProfileView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var mainTabVM: MainTabVM
    @StateObject private var viewModel = ProfileVM()
    private let buttonComponents = ButtonComponents()
    private let textComponent = TextComponent()
    @State private var activeScreen: ProfileNavigation? = nil
    @State private var selectedImage: UIImage?
    @Binding var currentTab: Int
    @State private var showEditView = false
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 0) {
                        ProfileHeaderView(viewModel: viewModel)
                        ProfileActionsView(currentTab: $currentTab)
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
                            .adaptiveForeground(light: .black, dark: .white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .onTapGesture { self.hideKeyboard() }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $activeScreen) { screen in
                switch screen {
                case .editProfile:
                    EditProfileView(viewModel: viewModel, activeScreen: $activeScreen, currentTab: $currentTab)
                case .changePassword:
                    ChangePasswordView(activeScreen: $activeScreen, currentTab: $currentTab)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchUserProfile()
                }
            }        }
    }
}


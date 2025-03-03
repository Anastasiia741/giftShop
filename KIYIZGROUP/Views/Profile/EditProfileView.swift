//  EditProfileView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/12/24.

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainTabVM: MainTabVM
    @ObservedObject var viewModel = ProfileVM()
    @Binding var activeScreen: ProfileNavigation?
    @Binding var currentTab: Int
    @State private var showChangePassword = false
    @State private var showAuthView = false
    @State private var showDeleteView = false
    @State private var showDropdown = false
    
    var body: some View {
        ZStack {
            VStack() {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 16)
                ScrollView {
                    VStack(spacing: 16) {
                        SectionHeader(title: "Контактные данные", showButton: true, action:  {
                            Task {
                                await viewModel.saveProfile()
                            }
                        })
                        RoundedField(placeholder: "Имя", borderColor: .gray, text: $viewModel.name)
                        RoundedField(placeholder: "Email", borderColor: .gray, text: $viewModel.email)
                            .disabled(true)
                        RoundedField(placeholder: "Номер телефона", borderColor: .gray, text: $viewModel.phone)
                        
                        RoundedPasswordButton(title: "Сменить пароль") {
                            activeScreen = .changePassword
                        }
                        SectionHeader(title: "Адрес доставки", showButton: false, action: nil)
                        Dropdown(placeholder: viewModel.selectedCity.isEmpty ? "Выберите город" : viewModel.selectedCity, options: viewModel.cities, selectedOption: $viewModel.selectedCity, isExpanded: $showDropdown)
                        RoundedField(placeholder: "Адрес", borderColor: .gray, text: $viewModel.address)
                        RoundedField(placeholder: "Номер квартиры", borderColor: .gray, text: $viewModel.appatment)
                        RoundedField(placeholder: "Этаж", borderColor: .gray, text: $viewModel.floor)
                        SectionHeader(title: "Аккаунт", showButton: false, action: nil)
                        RoundedButton(title: "Выйти из аккаунта") {
                            showAuthView.toggle()
                        }
                        RoundedRedButton(title: "Удалить аккаунт") {
                            showDeleteView.toggle()
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                .navigationDestination(isPresented: $viewModel.isShowQuit) {
                    TabBar(viewModel: mainTabVM)
                }
            }
            .navigationBarHidden(true)
            .onChange(of: currentTab) { oldValue, newValue in
                if oldValue != newValue {
                    dismiss()
                }
            }
            if viewModel.isSaving {
                showLoadingView()
            }
            
            if showAuthView {
                showLogoutAlert()
            }
            
            if showDeleteView {
                showDeleteAccountAlert()
            }
        }
    }
}

extension EditProfileView {
    private func showLoadingView() -> some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            LoadingView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        viewModel.isSaving = false
                    }
                }
        }
    }
}

extension EditProfileView {
    private func showLogoutAlert() -> some View {
        AlertView(title: "Вы действительно хотите выйти из аккаунта?", okButton: "Да", canselButton: "Нет", okButtonAction: {
            viewModel.logout(mainTabVM: mainTabVM)
        },
                  isOpenView: $showAuthView
        )
    }
}

extension EditProfileView {
    private func showDeleteAccountAlert() -> some View {
        AlertView(title: "Вы действительно хотите удалить аккаунт?", okButton: "Да", canselButton: "Нет", okButtonAction: {
            viewModel.deleteAccount {
                showDeleteView = false
            }
        },
                  isOpenView: $showDeleteView
        )
    }
}

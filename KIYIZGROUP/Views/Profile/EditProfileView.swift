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
                    LanguageToggleAuthView()
                }
                .padding([.horizontal, .top], 16)
                ScrollView {
                    VStack(spacing: 16) {
                        SectionHeader(title: "contact_details".localized, showButton: true, action:  {
                            Task {
                                await viewModel.saveProfile()
                            }
                        })
                        RoundedField(placeholder: "name".localized, borderColor: .gray, text: $viewModel.name)
                        RoundedField(placeholder: "email".localized, borderColor: .gray, text: $viewModel.email)
                            .disabled(true)
                        RoundedField(placeholder: "phone_number".localized, borderColor: .gray, text: $viewModel.phone)
                            .keyboardType(.numberPad)
                        RoundedPasswordButton(title: "change_password".localized) {
                            activeScreen = .changePassword
                        }
                        SectionHeader(title: "your_delivery_address".localized, showButton: false, action: nil)
                        Dropdown(placeholder: viewModel.selectedCity.isEmpty ? "select_city".localized : viewModel.selectedCity, options: viewModel.cities, selectedOption: $viewModel.selectedCity, isExpanded: $showDropdown)
                        RoundedField(placeholder: "address".localized, borderColor: .gray, text: $viewModel.address)
                        RoundedField(placeholder: "apartment_number".localized, borderColor: .gray, text: $viewModel.appatment)
                        RoundedField(placeholder: "floor_entrance".localized, borderColor: .gray, text: $viewModel.floor)
                        SectionHeader(title: "account".localized, showButton: false, action: nil)
                        RoundedButton(title: "logout".localized) { showAuthView.toggle() }
                        RoundedRedButton(title: "delete_your_account".localized) { showDeleteView.toggle() }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                .navigationDestination(isPresented: $viewModel.showQuit) {
                    TabBar(viewModel: mainTabVM)
                }
            }
            .onTapGesture { self.hideKeyboard() }
            .navigationBarHidden(true)
            .onChange(of: currentTab) { _, new_alue in
                dismiss()
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
        AlertView(title: "log_out".localized, okButton: "yes".localized, canselButton: "no".localized, okButtonAction: {
            viewModel.logout(mainTabVM: mainTabVM)
        },
                  isOpenView: $showAuthView
        )
    }
}

extension EditProfileView {
    private func showDeleteAccountAlert() -> some View {
        AlertView(title: "delete_account".localized, okButton: "yes".localized, canselButton: "no".localized, okButtonAction: {
            viewModel.deleteAccount {
                showDeleteView = false
            }
        },
                  isOpenView: $showDeleteView
        )
    }
}

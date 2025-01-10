//  EditProfileView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/12/24.

import SwiftUI

struct EditProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = ProfileVM()
    
    @State private var showAlertAnimation = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 16) {
                        SectionHeader(title: "Контактные данные")
                        RoundedField(placeholder: "Имя", text: $viewModel.name)
                            .onChange(of: viewModel.name) { oldValue, newValue in
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        RoundedField(placeholder: "Email", text: $viewModel.email)
                            .disabled(true)
                        RoundedField(placeholder: "Номер телефона", text: $viewModel.phoneNumber)
                            .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        NavigationLink(destination: ChangePasswordView()) {
                            RoundedPasswordButton(title: "Сменить пароль")
                        }
                        SectionHeader(title: "Адрес доставки")
                        RoundedField(placeholder: "Адрес", text: $viewModel.address)
                            .onChange(of: viewModel.address) { oldValue, newValue in
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        RoundedField(placeholder: "Номер квартиры", text: $viewModel.appartment)
                            .onChange(of: viewModel.address) { oldValue, newValue in
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        RoundedField(placeholder: "Этаж", text: $viewModel.floor)
                            .onChange(of: viewModel.address) { oldValue, newValue in
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        SectionHeader(title: "Аккаунт")
                        RoundedButton(
                            title: "Выйти из аккаунта"
                        ) {
                            viewModel.showLogoutConfirmationAlert()
                        }
                        RoundedRedButton(
                            title: "Удалить аккаунт"
                        ) {
                            viewModel.showDeleteConfirmationAlert()
                        }
                    }
                    .padding(.top, 70)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Color.white.opacity(0.9)
                        .edgesIgnoringSafeArea(.top)
                )
                
                if let alertModel = viewModel.alertModel {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.alertModel = nil
                                showAlertAnimation = false
                            }
                        }
                    
                    if let alertModel = viewModel.alertModel {
                        ZStack {
                            Color.black.opacity(showAlertAnimation ? 0.4 : 0)
                                .edgesIgnoringSafeArea(.all)
                                .animation(.easeInOut(duration: 0.6), value: showAlertAnimation)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.6)) {
                                        showAlertAnimation = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            viewModel.alertModel = nil
                                        }
                                    }
                                }
                            
                            VStack {
                                CustomAlertView(
                                    title: alertModel.title ?? "",
                                    message: alertModel.message ?? "",
                                    primaryButtonTitle: alertModel.buttons.first?.title ?? "OK",
                                    primaryButtonAction: {
                                        withAnimation(.easeInOut(duration: 0.6)) {
                                            alertModel.buttons.first?.action?()
                                            showAlertAnimation = false
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                            viewModel.showQuitPresenter = true
                                            viewModel.alertModel = nil
                                        }
                                    },
                                    secondaryButtonTitle: alertModel.buttons.dropFirst().first?.title,
                                    secondaryButtonAction: {
                                        withAnimation(.easeInOut(duration: 0.6)) {
                                            showAlertAnimation = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                viewModel.alertModel = nil
                                            }
                                        }
                                    }
                                )
                                .frame(maxWidth: 300)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 10)
                                .offset(y: showAlertAnimation ? 0 : UIScreen.main.bounds.height)
                                .animation(.easeInOut(duration: 0.8), value: showAlertAnimation)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 0.8)) {
                                        showAlertAnimation = true
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
            .onDisappear {
                Task {
                    await viewModel.saveProfile()
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showQuitPresenter) {
            NavigationView {
                TabBar(viewModel: MainTabVM())
            }
        }
        .navigationBarHidden(true)
    }
}



struct SectionHeader: View {
    private let textComponent = TextComponent()
    let title: String
    var body: some View {
        textComponent.createText(text: title.uppercased(), fontSize: 14, fontWeight: .regular, color: .gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
    }
}

struct RoundedField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.gray, lineWidth: 1.3)
            )
            .frame(height: 50)
    }
}


struct RoundedPasswordButton: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let title: String
    
    var body: some View {
        HStack{
            textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(colorScheme == .dark ? .white : .gray)
        }
        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(Color.gray, lineWidth: 1.3)
        )
    }
    
}



struct RoundedButton: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.gray, lineWidth: 1.3)
                )
        }
    }
}


struct RoundedRedButton: View {
    private let textComponent = TextComponent()
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: .r)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.gray, lineWidth: 1.3)
                )
        }
    }
}




struct CustomAlertView: View {
    private let textComponent = TextComponent()
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryButtonAction: (() -> Void)?
    let secondaryButtonTitle: String?
    let secondaryButtonAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            textComponent.createText(text: title, fontSize: 18, fontWeight: .bold, color: .black)
                .multilineTextAlignment(.center)
            textComponent.createText(text: message, fontSize: 12, fontWeight: .bold, color: .gray)
            HStack {
                if let secondaryButtonTitle = secondaryButtonTitle {
                    Button(action: {
                        secondaryButtonAction?()
                    }) {
                        textComponent.createText(text: secondaryButtonTitle, fontSize: 14, fontWeight: .bold, color: .black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(24)
                    }
                }
                Button(action: {
                    primaryButtonAction?()
                }) {
                    textComponent.createText(text: primaryButtonTitle, fontSize: 16, fontWeight: .bold, color: .black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorGreen.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(24)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
        )
        .padding()
    }
}

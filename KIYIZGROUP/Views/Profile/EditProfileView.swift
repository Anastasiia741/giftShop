//  EditProfileView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/12/24.

import SwiftUI

struct EditProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ProfileVM()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    SectionHeader(title: "Контактные данные")
                    RoundedField(placeholder: "Имя", text: $viewModel.name)
                        .onChange(of: viewModel.name) { oldValue, newValue in
                            Task {
                                print("Изменено имя с \(oldValue) на \(newValue)")
                                await viewModel.saveProfile()
                            }
                        }
                    RoundedField(placeholder: "Email", text: $viewModel.email)
                        .disabled(true)
                    RoundedField(placeholder: "Номер телефона", text: $viewModel.phoneNumber)
                        .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
                            if oldValue != newValue {
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        }
                    NavigationLink(destination: ChangePasswordView()) {
                        RoundedPasswordButton(title: "Сменить пароль")
                    }
                    SectionHeader(title: "Адрес доставки")
                    RoundedField(placeholder: "Адрес", text: $viewModel.address)
                        .onChange(of: viewModel.address) { oldValue, newValue in
                            if oldValue != newValue {
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        }
                    RoundedField(placeholder: "Номер квартиры", text: $viewModel.appartment)
                        .onChange(of: viewModel.address) { oldValue, newValue in
                            if oldValue != newValue {
                                Task {
                                    await viewModel.saveProfile()
                                }
                            }
                        }
                    RoundedField(placeholder: "Этаж", text: $viewModel.floor)
                        .onChange(of: viewModel.address) { oldValue, newValue in
                            if oldValue != newValue {
                                Task {
                                    await viewModel.saveProfile()
                                }
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
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        
        .onDisappear {
            Task {
                await viewModel.saveProfile()
            }
        }
        .alert(item: $viewModel.alertModel) { alertModel in
            Alert(title: Text(alertModel.title ?? ""), message: Text(alertModel.message ?? ""), primaryButton: alertModel.buttons.first.map { button in
                    .default(Text(button.title), action: button.action)
            } ?? .default(Text("OK")),
                  secondaryButton: alertModel.buttons.dropFirst().first.map { button in
                    .destructive(Text(button.title), action: button.action)
            } ?? .cancel()
            )
        }
        .fullScreenCover(isPresented: $viewModel.showQuitPresenter) {
            NavigationView {
                TabBar(viewModel: MainTabVM())
            }
        }
        
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

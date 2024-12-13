//  EditProfileView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/12/24.

import SwiftUI

struct EditProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ProfileVM
    @State private var isQuitAlertPresenter = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionHeader(title: "Контактные данные")
                
                RoundedField(placeholder: "Имя", text: $viewModel.name)
                RoundedField(placeholder: "Email", text: $viewModel.email)
                RoundedField(placeholder: "Номер телефона", text: $viewModel.phoneNumber)
                
                RoundedButton(
                    title: "Сменить пароль"
                ) {
                }
                
                SectionHeader(title: "Адрес доставки")
                
                RoundedField(placeholder: "Адрес", text: $viewModel.address)
                RoundedField(placeholder: "Номер квартиры", text: $viewModel.address)
                RoundedField(placeholder: "Этаж", text: $viewModel.address)
                
                SectionHeader(title: "Аккаунт")
                
                RoundedButton(
                    title: "Выйти из аккаунта"
                ) {
                    isQuitAlertPresenter.toggle()
                }
                
                RoundedRedButton(
                    title: "Удалить аккаунт"
                ) {
                    
                    viewModel.deleteAccount {
                        //
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        
        .alert(isPresented: $isQuitAlertPresenter) {
            Alert(
                title: Text("Выйти из аккаунта"),
                message: Text("Вы действительно хотите выйти?"),
                primaryButton: .destructive(Text("Да")) {
                    viewModel.logout()
                },
                secondaryButton: .cancel(Text("Отмена"))
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

struct RoundedButton: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, minHeight: 50)
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
                .frame(maxWidth: .infinity, minHeight: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.gray, lineWidth: 1.3)
                )
        }
    }
    
    
}

//  TextFieldView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationFieldsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = AuthorizationVM()
    private let textComponent = TextComponent()
    private let customTextField = CustomTextField()
    private let customSecureField = CustomSecureField()
    private let customButton = CustomButtonLogIn()
    @State private var isButtonPressed = false
    @State private var isPasswordVisible = false
    @State private var showTabView = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                textComponent.createText( text: Localization.authorization, fontSize: 24, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6)
                customTextField.createTextField(placeholder: Localization.email, text: $viewModel.email, color: colorScheme == .dark ? .white : .black, borderColor: viewModel.errorType == .email ? .r : Color.colorDarkBrown)
                    .padding(6)
                HStack{
                    customSecureField.createSecureField(placeholder: Localization.createPassword, text: $viewModel.password, isPasswordVisible: $isPasswordVisible,
                                                        color: colorScheme == .dark ? .white : .black,
                                                        borderColor: viewModel.errorType == .password ? .r : .colorDarkBrown)
                    customButton.createButton(foregroundColor: .white, backgroundColor: viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.clear : .colorGreen, borderColor: viewModel.email.isEmpty || viewModel.password.isEmpty ? .gray : .colorGreen, isEnabled: !(viewModel.email.isEmpty || viewModel.password.isEmpty),action: {
                        Task{
                            await viewModel.signIn()
                            if viewModel.isTabViewShow {
                                //
                            }
                        }
                    })
                }
                .padding(6)
                if viewModel.errorType == .password || viewModel.errorType == .general || viewModel.errorType == .email {
                    textComponent.createText(text: viewModel.errorMessage, fontSize: 12, fontWeight: .regular, color: Color.r)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
        }
    }
}




//
//            if AuthService().currentUser?.uid == Accesses.adminUser {
//                TabBar(viewModel: MainTabVM())
//                    .customTransition(isPresented: $showTabView)
//            } else {
//                let mainTabBarVM = MainTabVM()
//                TabBar(viewModel: mainTabBarVM)
//                    .customTransition(isPresented: $showTabView)
//            }

//  TextFieldView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationFieldsView: View {
    @EnvironmentObject var mainTabVM: MainTabVM
    @ObservedObject var viewModel: AuthorizationVM
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    private let customButton = CustomButtonLogIn()
    @State private var isPasswordVisible = false
    @Binding var showCatalog: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                textComponent.createText(text: "authorization".localized, fontSize: 24, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6)
                textFieldComponent.createCustomTextField(placeholder: "email".localized, text: $viewModel.email, borderColor: viewModel.errorType == .email ? .r : .colorDarkBrown)
                    .padding(6)
                HStack {
                    textFieldComponent.createSecureField(placeholder: "enter_password".localized, text: $viewModel.password,
                                                         isPasswordVisible: $isPasswordVisible,
                                                         color: Color.primary,
                                                         borderColor: viewModel.errorType == .password ? .r : .colorDarkBrown)
                    
                    customButton.createButton(foregroundColor: .white,
                                              backgroundColor: viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.clear : .colorGreen,
                                              borderColor: viewModel.email.isEmpty || viewModel.password.isEmpty ? .gray : .colorGreen,
                                              isEnabled: !(viewModel.email.isEmpty || viewModel.password.isEmpty),action: {
                        Task{
                            await viewModel.signIn {
                                DispatchQueue.main.async {
                                    showCatalog = true
                                }
                            }
                        }
                    })
                }
                .padding(6)
                if viewModel.errorType == .password || viewModel.errorType == .general || viewModel.errorType == .email {
                    textComponent.createText(text: viewModel.errorMessage ?? "", fontSize: 12, fontWeight: .regular, lightColor: .r, darkColor: .r)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
}




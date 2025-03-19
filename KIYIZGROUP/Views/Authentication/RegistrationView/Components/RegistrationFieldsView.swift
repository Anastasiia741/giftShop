//  RegistrFieldsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct RegistrationFieldsView: View {
    @ObservedObject var viewModel: RegistrationVM
    let customButton: CustomButton
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(spacing: 8) {
            textComponent.createText(text: "registration".localized, fontSize: 24, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
    
            textFieldComponent.createCustomTextField(placeholder: "Email", text: $viewModel.email, borderColor: viewModel.errorType == .email ? .red : .colorDarkBrown)
                .padding(6)
            
            textFieldComponent.createSecureField(placeholder: "create_password".localized,
                                                text: $viewModel.password,
                                                isPasswordVisible: $isPasswordVisible, color: Color.primary,
                                                borderColor: viewModel.errorType == .password ? .red : .colorDarkBrown)
                .padding(6)
            
            if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                textComponent.createText(text: errorMessage, fontSize: 14, fontWeight: .regular, lightColor: .r, darkColor: .r)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            customButton.createButton(text: "register".localized, fontSize: 16, fontWeight: .regular,
                                      color: viewModel.email.isEmpty || viewModel.password.isEmpty ? .gray : .white,
                                      backgroundColor: viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.clear : Color.colorGreen,
                                      borderColor: viewModel.email.isEmpty || viewModel.password.isEmpty ? .gray : .colorGreen) {
                                        viewModel.signUp()}
                              .padding(6)
                              .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
        }
        .padding(.horizontal)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}


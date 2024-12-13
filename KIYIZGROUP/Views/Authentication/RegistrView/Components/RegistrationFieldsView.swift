//  RegistrFieldsView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct RegistrationFieldsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = AuthenticationVM()
    private let textComponent = TextComponent()
    var onAuthenticationSuccess: (String) -> Void
    @State private var isButtonPressed = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                textComponent.createText(text: Localization.registration, fontSize: 24, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField(Localization.email, text: $viewModel.email)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(viewModel.errorType == .email ? Color.red : Color.colorDarkBrown, lineWidth: 1.3)
                    )
                    .frame(height: 50)
                
                HStack {
                    if isPasswordVisible {
                        TextField(Localization.createPassword, text: $viewModel.password)
                            .padding()
                    } else {
                        SecureField(Localization.createPassword, text: $viewModel.password)
                            .padding()
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(isPasswordVisible ? "eye" : "eye.slash")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.trailing, 16)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(viewModel.errorType == .password ? Color.red : Color.colorDarkBrown, lineWidth: 1.3)
                )
                .frame(height: 50)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    if let errorMessage = viewModel.validateFields() {
                        viewModel.updateError(message: errorMessage, type: .general)
                    } else {
                        viewModel.signUp()
                        if viewModel.errorMessage.isEmpty {
                            isButtonPressed = true
                        }
                    }
                }) {
                    textComponent.createText(
                        text: Localization.registr,
                        fontSize: 16,
                        fontWeight: .regular,
                        color: viewModel.email.isEmpty || viewModel.password.isEmpty ? .gray : .white
                    )
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.clear : Color.colorGreen)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.gray : Color.colorGreen, lineWidth: 1.3)
                    )
                }
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $viewModel.isFinalRegistration) {
            RegistrationConfirmationView(
                email: viewModel.email,
                onAuthenticationSuccess: onAuthenticationSuccess
            )
        }
    }
}

//
//if viewModel.isFinalRegistration {
//    RegistrationConfirmationView(
//        email: viewModel.email,
//        onAuthenticationSuccess: onAuthenticationSuccess
//    )
//    .transition(.move(edge: .trailing))
//}

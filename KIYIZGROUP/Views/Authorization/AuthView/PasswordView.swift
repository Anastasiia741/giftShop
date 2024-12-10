//  PasswordView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct PasswordView: View {
//    @ObservedObject var viewModel: AuthViewModel
    @State private var showError = false
    
    @State var isAuthenticated: Bool

    var body: some View {
        VStack {
            Spacer()
            AnimatedImagesView()
            Spacer()
            PasswordFieldView(isAuthenticated: $isAuthenticated)
               

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .onTaGesture {
            self.hideKeyboard()
        }
    }
       
}


struct PasswordFieldView: View {
//    @ObservedObject var viewModel: AuthViewModel
    @Binding var isAuthenticated: Bool

    @State private var showError = false

    var body: some View {
        VStack(spacing: 20) {
//            SecureField("Введите пароль", text: $viewModel.password)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(8)
//                .onChange(of: viewModel.password) {
//                    viewModel.isPasswordValid = viewModel.password.count >= 6
//                }
//
//            if let errorMessage = viewModel.errorMessage {
//                           Text(errorMessage)
//                               .foregroundColor(.red)
//                               .font(.caption)
//                       }
//
//
//            Button("Войти") {
//                viewModel.loginWithPassword { success in
//                    if success {
//                                           isAuthenticated = true
//                                       }
//                }
            }
//            .disabled(!viewModel.isPasswordValid)
//            .buttonStyle(.borderedProminent)
        }
       
}

//  TextFieldView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI
import FirebaseAuth

struct AuthFieldsView: View {
    @ObservedObject private var viewModel = MainAuthVM()
    var onAuthenticationSuccess: ((String) -> Void)
    @State private var isButtonPressed = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(viewModel.errorType == .email ? Color.red : Color.colorDarkBrown, lineWidth: 1.3)
                    )
                    .frame(height: 50)
                    .padding(.leading, 8)
                    .padding(.vertical)
                HStack(spacing: 8) {
                    HStack {
                        if isPasswordVisible {
                            TextField("Введите пароль", text: $viewModel.password)
                                .padding()
                        } else {
                            SecureField("Введите пароль", text: $viewModel.password)
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
                    .padding(.leading, 8)
                    Button(action: {
                        Task {
                            await viewModel.signIn()
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(viewModel.email.isEmpty || viewModel.password.isEmpty ? .gray : .white)
                            .frame(width: 54, height: 54)
                            .background(
                                Circle()
                                    .fill(viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.clear : Color.colorGreen)
                                    .overlay(
                                        Circle()
                                            .stroke(viewModel.email.isEmpty || viewModel.password.isEmpty ? Color.gray : Color.colorGreen, lineWidth: 1)
                                    )
                            )
                    }
                }
                if viewModel.errorType == .password || viewModel.errorType == .general || viewModel.errorType == .email {
                    Text(viewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            }
        }
        .padding(.horizontal)
        //        //
        .fullScreenCover(isPresented: $viewModel.isTabViewShow) {
            if AuthService().currentUser?.uid == Accesses.adminUser {
                TabBar(viewModel: MainTabVM())
            } else {
                let mainTabBarVM = MainTabVM()
                TabBar(viewModel: mainTabBarVM)
            }
        }
    }
}




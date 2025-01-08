//  TextFieldView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationFieldsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = AuthenticationVM()
    private let textComponent = TextComponent()
    @State private var isButtonPressed = false
    @State private var isPasswordVisible = false
    @State private var showTabView = false
    //    @State private var activeScreen: ActiveScreen? = nil
    @State private var showAdminTab = false
    @State private var showUserTab = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                textComponent.createText( text: Localization.authorization, fontSize: 24, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                TextField(Localization.email, text: $viewModel.email)
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
                            TextField(Localization.enterPassword, text: $viewModel.password)
                                .padding()
                        } else {
                            SecureField(Localization.enterPassword, text: $viewModel.password)
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
                            if viewModel.isTabViewShow {
                                withAnimation {
                                    showTabView.toggle()
                                }
                            }
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
                    textComponent.createText(text: viewModel.errorMessage, fontSize: 12, fontWeight: .regular, color: Color.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                }
            }
            .padding(.horizontal)
            
            //
            //            if AuthService().currentUser?.uid == Accesses.adminUser {
            //                TabBar(viewModel: MainTabVM())
            //                    .customTransition(isPresented: $showTabView)
            //            } else {
            //                let mainTabBarVM = MainTabVM()
            //                TabBar(viewModel: mainTabBarVM)
            //                    .customTransition(isPresented: $showTabView)
            //            }
            
        }
    }
}




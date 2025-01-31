//  ChangePasswordView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 7/1/25.

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = ChangePassword()
    private let textComponent = TextComponent()
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var isSuccess: Bool = false
    @Binding var activeScreen: ProfileNavigation?
  

    
    var body: some View {
        VStack {
            HStack {
               BackButton {
                   activeScreen = .editProfile
               }
                Spacer()
            }
            .padding([.leading, .top], 16)
           
            VStack(spacing: 16) {
                
                textComponent.createText(text: "Change Password", fontSize: 20, fontWeight: .heavy, color:  colorScheme == .dark ? .white : .black)
                    .padding(.top, 20)
                textComponent.createText(text: "You will be signed out upon changing your password and required to sign back into the app.", fontSize: 18, fontWeight: .regular, color: .gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                SecureField("Current Password", text: $viewModel.currentPassword)
                    .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.gray, lineWidth: 1.3)
                    )
                SecureField("New Password", text: $viewModel.newPassword)
                    .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.gray, lineWidth: 1.3)
                    )
                if let errorMessage = viewModel.errorMessage {
                    textComponent.createText(text: errorMessage, fontSize: 12, fontWeight: .regular, color: .red)
                }
                if let successMessage = viewModel.successMessage {
                    textComponent.createText(text: successMessage, fontSize: 12, fontWeight: .regular, color: .green)
                }
                Button(action: {
                    viewModel.changePassword()
                }) {
                    if viewModel.isLoading {
                        LoadingView()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.colorGreen)
                            .cornerRadius(40)
                    } else {
                        textComponent.createText(text: "Save Password", fontSize: 16, fontWeight: .regular, color: .white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.colorGreen)
                            .cornerRadius(40)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


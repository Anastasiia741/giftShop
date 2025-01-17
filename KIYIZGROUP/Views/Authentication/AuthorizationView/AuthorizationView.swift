//  AuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var viewModel = AuthorizationVM()
    @State private var isShowView = false

    var body: some View {
            VStack {
                Spacer()
                AnimatedImagesView()
                Spacer()
                AuthorizationFieldsView()
                    .padding(.horizontal)
                ForgotPasswordButton().createButton(action: {
                    isShowView.toggle()
                })
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .onTapGesture {
                self.hideKeyboard()
                UIApplication.shared.endEditing()
            }
            if isShowView {
                ForgotPasswordView(isOpenView: $isShowView)
            }
        
    }
}




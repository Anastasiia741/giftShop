//  AuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var viewModel = AuthenticationVM()
    var onBack: () -> Void

    var body: some View {
        VStack {
            Spacer()
            AnimatedImagesView()
            Spacer()
            AuthorizationFieldsView()
                .padding(.horizontal)
            ForgotPasswordView()
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .overlay(
            HStack {
                CustomBackButton(onBack: onBack)
                    .padding(.horizontal)
                Spacer()
                
            }
                .padding()
                .frame(maxHeight: 44),
            alignment: .top
        )
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
    }
}

extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

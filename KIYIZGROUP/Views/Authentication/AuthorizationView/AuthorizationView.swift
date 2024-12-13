//  AuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var viewModel = AuthenticationVM()
    var onAuthenticationSuccess: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            AnimatedImagesView()
            Spacer()
            AuthorizationFieldsView(onAuthenticationSuccess: onAuthenticationSuccess) 
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: ForgotPasswordView())
        .navigationBarItems(leading: CustomBackButton())
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

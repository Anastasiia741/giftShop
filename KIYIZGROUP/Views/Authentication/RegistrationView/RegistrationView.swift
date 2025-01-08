//  RegistrView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct RegistrationView: View {
    @ObservedObject private var viewModel = AuthenticationVM()
    var onBack: () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            AnimatedImagesView()
            Spacer()
            RegistrationFieldsView(onAuthenticationSuccess: { _ in
            })
            Spacer()

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


//  RegistrView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct RegistrationView: View {
    @ObservedObject private var viewModel = AuthenticationVM()
    var onRegistrationSuccess: () -> Void

    var body: some View {
        VStack{
            Spacer()
            AnimatedImagesView()
            Spacer()
            RegistrationFieldsView(onAuthenticationSuccess: { _ in
                onRegistrationSuccess()
            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}


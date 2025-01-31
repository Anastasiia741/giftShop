//  RegistrView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = RegistrationVM()
    private let customButton = CustomButton()
    private let simpleButton = MinimalButton()
    
    var body: some View {
            VStack {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 16)
                Spacer()
                AnimatedImagesView()
                Spacer()
                RegistrationFieldsView(viewModel: viewModel, customButton: customButton)
                Spacer()
                simpleButton.createMinimalButton(text: Localization.privacyPolicy, fontSize: 12, fontWeight: .regular, color: colorScheme == .dark ? .white : .black) {
                    viewModel.disclaimerTapped()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.leading, 16)
            }
            .onTapGesture {
                self.hideKeyboard()
                UIApplication.shared.endEditing()
            }
            .navigationDestination(isPresented: $viewModel.isShowConfirmView) {
                ConfirmationView(customButton: customButton, email: viewModel.email)
            }
    }
}

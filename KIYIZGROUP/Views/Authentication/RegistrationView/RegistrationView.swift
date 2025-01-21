//  RegistrView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel = RegistrationVM()
    private let textComponent = TextComponent()
    private let customButton = CustomButton()
    private let simpleButton = MinimalButton()
    @State private var isNavigatingToConfirmation = false

    var body: some View {
        CustomNavigationView(
            isActive: $isNavigatingToConfirmation,
            destination: {
                RegistrationConfirmationView(customButton: customButton)
            },
            content: {
                VStack {
                    Spacer()
                    AnimatedImagesView()
                    Spacer()
                    RegistrationFieldsView(customButton: customButton, onAuthenticationSuccess: { email in
                        withAnimation {
                            isNavigatingToConfirmation = true
                        }
                    })
                    HStack(spacing: 4) { 
                        textComponent.createText(text: Localization.pressPolicy, fontSize: 12, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        
                        simpleButton.createMinimalButton(text: Localization.privacyPolicy, fontSize: 12, fontWeight: .regular, color: colorScheme == .dark ? .white : .black) {
                            viewModel.disclaimerTapped()
                        }.underline()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 20)
                    .padding(.leading, 26)
                    Spacer()
                }
                .onTapGesture {
                    self.hideKeyboard()
                    UIApplication.shared.endEditing()
                }
            }
        )
    }
}


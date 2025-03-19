//  RegistrationConfirmationView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct ConfirmationView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let customButton: CustomButton
    let email: String
    @Binding var currentTab: Int
    @State private var showAuthView = false
    
    var body: some View {
        VStack {
            VStack{
                Spacer()
                textComponent.createText(text: "congratulations".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    .padding(.vertical)
                HStack{
                    textComponent.createText(text: email, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    textComponent.createText(text: "successfully_registered".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                }
                .padding(.vertical)
                
                textComponent.createText(text: "complete_authorization".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    .padding(.vertical)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            VStack(spacing: 16) {
                customButton.createButton(text: "sign_in".localized, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black, backgroundColor: .clear, borderColor: .colorDarkBrown,action: {
                    showAuthView = true
                })
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
            }
            .navigationDestination(isPresented: $showAuthView) {
                AuthorizationView(currentTab: $currentTab)
            }
        }        
        .navigationBarBackButtonHidden(true)
    }
}


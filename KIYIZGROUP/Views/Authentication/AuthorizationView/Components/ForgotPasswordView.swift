//  ForgotPasswordView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct ForgotPasswordView: View, InfoDialogHandling {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = AuthorizationVM()
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    let customButton = CustomButton()
    @State private var title = "Восстановление пароля"
    @State private var email = ""
    @State private var offset: CGFloat = 1000
    var isOpenView: Binding<Bool>
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
                .onTapGesture {
                    self.closeInfoDialog()
                }
            VStack {
                Spacer()
                textComponent.createText(text: title, fontSize: 18, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.vertical, .horizontal])
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                textFieldComponent.createCustomTextField(placeholder: "Введите ваш email", text: $email, color: colorScheme == .dark ? .white : .black, borderColor: .colorDarkBrown)
                    .padding([.horizontal])
                Spacer()
                customButton.createButton(text: email.isEmpty ? "Закрыть" : "Отправить", fontSize: 18, fontWeight: .medium, color: .black, backgroundColor: colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2), borderColor: .clear, cornerRadius: 100, action: {
                    if email.isEmpty {
                        closeDialog()
                    } else {
                        handlePasswordReset()
                    }
                })
                .frame(width: 273, height: 60)
                .padding(.bottom)
            }
            .frame(width: 300, height: 250)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.colorBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
            .zIndex(1)
        }
        .ignoresSafeArea()
    }
}

extension ForgotPasswordView {
    private func closeDialog() {
        withAnimation(.spring()) {
            offset = 1000
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            closeInfoDialog()
        }
    }
    
    private func handlePasswordReset() {
        viewModel.email = email
        viewModel.resetPassword { success, errorMessage in
            if success {
                title = "Пароль был отправлен на \(email)"
                email = ""
            } else if let errorMessage = errorMessage {
                title = errorMessage
                email = ""
            }
        }
    }
}

protocol InfoDialogHandling {
    var isOpenView: Binding<Bool> { get }
    func closeInfoDialog()
}

extension InfoDialogHandling {
    func closeInfoDialog() {
        
        withAnimation(.easeInOut) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isOpenView.wrappedValue = false
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(isOpenView: .constant(true))
    }
}


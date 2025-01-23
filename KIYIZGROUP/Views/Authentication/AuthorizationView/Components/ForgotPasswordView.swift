//  ForgotPasswordView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct ForgotPasswordView: View, InfoDialogHandling {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = AuthorizationVM()
    private let textComponent = TextComponent()
    private let customTextField = CustomTextField()
    let customButton = CustomButton()
    var description: String? = nil
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
                textComponent.createText(text: title, fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.vertical, .horizontal])
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                customTextField.createTextField(placeholder: "Введите ваш email", text: $email, color: colorScheme == .dark ? .white : .black, borderColor: .colorDarkBrown)
                    .padding([.vertical, .horizontal])
                
                customButton.createButton(text: email.isEmpty ? "Закрыть" : "Отправить", fontSize: 18, fontWeight: .medium, color: .black, backgroundColor: colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2), borderColor: .clear, cornerRadius: 100, action: {
                    if email.isEmpty {
                        closeDialog()
                    } else {
                        handlePasswordReset()
                    }
                })
                .frame(width: 273, height: 60)
                .padding(.bottom, 20)
            }
            .frame(width: 300, height: 250)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
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
        viewModel.sendPasswordResetEmail { success, errorMessage in
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


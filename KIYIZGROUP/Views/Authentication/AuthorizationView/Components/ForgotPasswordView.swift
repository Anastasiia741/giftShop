//  ForgotPasswordView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/12/24.

import SwiftUI

struct ForgotPasswordView: View, InfoDialogHandling {
    var isOpenView: Binding<Bool>
    
    func sendEmail() {
        //
    }
    
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    private let customTextField = CustomTextField()
    let customButton = CustomButton()
    var description: String? = nil
    @State private var email: String = ""
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.closeInfoDialog()
                }
            VStack {
                Spacer()
                textComponent.createText(text: "Восстановление пароля", fontSize: 18, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .padding(.vertical)
                customTextField.createTextField(placeholder: "Введите ваш email", text: $email, color: colorScheme == .dark ? .white : .black, borderColor: .colorDarkBrown)
                    .padding(.horizontal)
                    .padding(.vertical)
                customButton.createButton(text: email.isEmpty ? "Закрыть" : "Отправить", fontSize: 18, fontWeight: .medium, color: .black, backgroundColor: colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2), borderColor: .clear, cornerRadius: 100, action: {
                    if email.isEmpty {
                        closeInfoDialog()
                    } else {
                        sendEmail()
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


protocol InfoDialogHandling {
    var isOpenView: Binding<Bool> { get }
    func closeInfoDialog()
    func sendEmail(email: String)
}

extension InfoDialogHandling {
    func closeInfoDialog() {
        withAnimation(.easeInOut) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isOpenView.wrappedValue = false
            }
        }
    }
    
    func sendEmail(email: String) {
        print("Отправить на email: \(email)")
        closeInfoDialog()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(isOpenView: .constant(true))
    }
}


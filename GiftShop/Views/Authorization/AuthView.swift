//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var alertMessage = ""
    @State private var isTabViewShow = false
    @State private var isShowAlert = false
    @State private var isAuth = true
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(isAuth ? TextMessage.Authorization.authorization : TextMessage.Authorization.registration)
                .padding(isAuth ? 16 : 18)
                .padding(.horizontal, 30)
                .font(.title2.bold())
                .background(Colors.whiteAlfa)
                .cornerRadius(isAuth ? 30 : 40)
                .padding(.horizontal, 12)
            VStack{
                TextField("Введите email", text: $email)
                    .padding()
                    .background(Colors.whiteAlfa)
                    .cornerRadius(12)
                    .padding(4)
                    .padding(.horizontal, 12)
                SecureField("Введите пароль", text: $password)
                    .padding()
                    .background(Colors.whiteAlfa)
                    .cornerRadius(12)
                    .padding(4)
                    .padding(.horizontal, 12)
                if !isAuth {
                    SecureField("Повторите пароль", text: $confirmPassword)
                        .padding()
                        .background(Colors.whiteAlfa)
                        .cornerRadius(12)
                        .padding(4)
                        .padding(.horizontal, 12)
                }
                Button {
                    if isAuth {
                        AuthService.shared.signIn(email: email, password: password) { result in
                            switch result {
                            case .success(_):
                                isTabViewShow.toggle()
                            case .failure(let error):
                                alertMessage = "Registration error \(error.localizedDescription)"
                                isShowAlert.toggle()
                            }
                        }
                    } else {
                        guard password == confirmPassword else {
                            self.alertMessage = "Пароли не совпадают"
                            self.isShowAlert.toggle()
                            return
                        }
                        AuthService.shared.signUp(email: self.email, password: self.password) { result in
                            switch result {
                            case .success(_):
                                self.isShowAlert.toggle()
                                self.email = ""
                                self.password = ""
                                self.confirmPassword = ""
                                self.isAuth.toggle()
                            case .failure(let error):
                                alertMessage = "Registration error \(error.localizedDescription)"
                                self.isShowAlert.toggle()
                            }
                        }
                    }
                }
            label: {
                Text(isAuth ? "Войти" : TextMessage.Authorization.registration)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [Colors.yellow, Colors.red], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(8)
                    .padding(8)
                    .padding(.horizontal, 12)
                    .font(.title3.bold())
                    .foregroundColor(.black)
            }
                Button {
                    isAuth.toggle()
                } label: {
                    Text(isAuth ? "Регистрация" : "Уже есть аккаунт")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .padding(8)
                        .padding(.horizontal, 12)
                        .font(.title3.bold())
                        .foregroundColor(Colors.brown)
                }
            }
            .padding()
            .padding(.top, 16)
            .background(Colors.whiteAlfa)
            .cornerRadius(24)
            .padding(isAuth ? 30 : 12)
            Images.Auth.background
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: isAuth ? 0 : 6)
        }
        .animation(.easeInOut(duration: 0.3), value: isAuth)
        .fullScreenCover(isPresented: $isTabViewShow) {
            if AuthService.shared.currentUser?.uid == Accesses.currentUser {
                OrdersView()
            } else {
                let mainTabBarVM = MainTabViewModel(user: AuthService.shared.currentUser!)
                TabBar(viewModel: mainTabBarVM)
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text(AlertMessage.errorTitle), message: Text(alertMessage), dismissButton: .default(Text(AlertMessage.applyAction)))
        }
    }
}

#Preview {
    AuthView()
}

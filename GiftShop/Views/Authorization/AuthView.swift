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
    private let authService = AuthService()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(isAuth ? "Авторизация" : "Регистрация")
                .padding(isAuth ? 16 : 18)
                .padding(.horizontal, 30)
                .font(.title2.bold())
                .background(Color("whiteAlfa"))
                .cornerRadius(isAuth ? 30 : 40)
                .padding(.horizontal, 12)
            VStack{
                TextField("Введите email", text: $email)
                    .padding()
                    .background(Color("whiteAlfa"))
                    .cornerRadius(12)
                    .padding(4)
                    .padding(.horizontal, 12)
                SecureField("Введите пароль", text: $password)
                    .padding()
                    .background(Color("whiteAlfa"))
                    .cornerRadius(12)
                    .padding(4)
                    .padding(.horizontal, 12)
                if !isAuth {
                    SecureField("Повторите пароль", text: $confirmPassword)
                        .padding()
                        .background(Color("whiteAlfa"))
                        .cornerRadius(12)
                        .padding(4)
                        .padding(.horizontal, 12)
                }
                Button {
                    if isAuth {
                        print("авторизация пользователя")
                        authService.signIn(email: email, password: password) { result in
                            switch result {
                            case .success(_):
                                isTabViewShow.toggle()
                            case .failure(let error):
                                alertMessage = "Registration error \(error.localizedDescription)"
                                isShowAlert.toggle()
                            }
                        }
                    } else {
                        print("регистрация пользователя")
                        guard password == confirmPassword else {
                            self.alertMessage = "Пароли не совпадают"
                            self.isShowAlert.toggle()
                            return
                        }
                        authService.signUp(email: self.email, password: self.password) { result in
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
                Text(isAuth ? "Войти" :  "Регистрация")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [Color("yellowColor"), Color("redColor")], startPoint: .leading, endPoint: .trailing))
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
                        .foregroundColor(Color("brownColor"))
                }
            }
            .padding()
            .padding(.top, 16)
            .background(Color("whiteAlfa"))
            .cornerRadius(24)
            .padding(isAuth ? 30 : 12)
            Image("authScreen")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: isAuth ? 0 : 6)
        }
        .animation(.easeInOut(duration: 0.3), value: isAuth)
        .fullScreenCover(isPresented: $isTabViewShow) {
            if authService.currentUser?.uid == "VZ8WXQXaV9fUdkfpQwAjRhaGk9w1" {
                OrdersView()
            } else {
                let mainTabBarVM = MainTabViewModel(user: authService.currentUser!)
                TabBar(viewModel: mainTabBarVM)
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AuthView()
}

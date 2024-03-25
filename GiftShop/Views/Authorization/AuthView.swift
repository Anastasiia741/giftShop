//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @ObservedObject private var viewModel = AuthVM()
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isTabViewShow = false
    @State private var isShowAlert = false
    @State private var isAuth = true
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(isAuth ? Localization.authorization : Localization.registration)
                .padding(isAuth ? 16 : 18)
                .padding(.horizontal, 30)
                .font(.title2.bold())
                .background(Colors.whiteAlfa)
                .cornerRadius(isAuth ? 30 : 40)
                .padding(.horizontal, 12)
            VStack{
                TextField(Localization.enterEmail, text: $viewModel.email)
                    .padding()
                    .background(Colors.whiteAlfa)
                    .cornerRadius(12)
                    .padding(4)
                    .padding(.horizontal, 12)
                SecureField(Localization.enterPassword, text: $viewModel.password)
                    .padding()
                    .background(Colors.whiteAlfa)
                    .cornerRadius(12)
                    .padding(4)
                    .padding(.horizontal, 12)
                if !isAuth {
                    SecureField(Localization.repeatPassword, text: $viewModel.confirmPassword)
                        .padding()
                        .background(Colors.whiteAlfa)
                        .cornerRadius(12)
                        .padding(4)
                        .padding(.horizontal, 12)
                }
                Button {
                    if isAuth {
                        AuthService().signIn(email: viewModel.email, password: viewModel.password) { result in
                            switch result {
                            case .success(_):
                                isTabViewShow.toggle()
                            case .failure(let error):
                                alertMessage = "\(Localization.registrationError) \(error.localizedDescription)"
                                isShowAlert.toggle()
                            }
                        }
                    } else {
                        guard viewModel.password == viewModel.confirmPassword else {
                            alertTitle = Localization.attention
                            alertMessage = Localization.passwordMismatch
                            isShowAlert.toggle()
                            return
                        }
                        AuthService().signUp(email: viewModel.email, password: viewModel.password) { result in
                            switch result {
                            case .success(_):
                                isShowAlert.toggle()
                                viewModel.email = ""
                                viewModel.password = ""
                                viewModel.confirmPassword = ""
                                alertTitle = Localization.congratulations
                                alertMessage = Localization.dataSavedSuccessfully
                                isAuth.toggle()
                            case .failure(let error):
                                alertTitle = Localization.registrationError
                                alertMessage = error.localizedDescription
                                isShowAlert.toggle()
                            }
                        }
                    }
                }
            label: {
                Text(isAuth ? Localization.authorization : Localization.registration)
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
                    Text(isAuth ? Localization.registration : Localization.alreadyHaveAccount)
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
            if AuthService().currentUser?.uid == Accesses.adminUser {
                OrdersView()
            } else {
                let mainTabBarVM = MainTabViewModel()
                TabBar(viewModel: mainTabBarVM)
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text(Localization.ok)))
        }
    }
}

#Preview {
    AuthView()
}

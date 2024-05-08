//  ContentView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @ObservedObject private var viewModel = AuthVM()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(viewModel.isAuth ? Localization.authorization : Localization.registration)
                .padding(viewModel.isAuth ? 16 : 18)
                .padding(.horizontal, 30)
                .font(.title2.bold())
                .background(Colors.whiteAlfa)
                .cornerRadius(viewModel.isAuth ? 30 : 40)
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
                if !viewModel.isAuth {
                    SecureField(Localization.repeatPassword, text: $viewModel.confirmPassword)
                        .padding()
                        .background(Colors.whiteAlfa)
                        .cornerRadius(12)
                        .padding(4)
                        .padding(.horizontal, 12)
                }
                Button {
                    if viewModel.isAuth {
                        Task {
                            await viewModel.signIn()
                        }
                    } else {
                        viewModel.signUp()
                    }
                }
            label: {
                Text(viewModel.isAuth ? Localization.authorization : Localization.registration)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [Colors.yellow, Colors.red], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(8)
                    .padding(8)
                    .padding(.horizontal, 12)
                    .font(.title3.bold())
                    .foregroundColor(.themeText)
            }
                Button {
                    viewModel.toggleAuthButton()
                } label: {
                    Text(viewModel.isAuth ? Localization.registration : Localization.alreadyHaveAccount)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        .padding(8)
                        .padding(.horizontal, 12)
                        .font(.title3.bold())
                        .foregroundColor(Colors.brown)
                }
                Button {
                    viewModel.disclaimerTapped()
                } label: {
                    Text(Localization.privacyPolicy)
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .padding(.horizontal, 12)
                        .font(.caption2.bold())
                        .foregroundColor(.themeText)
                }
            }
            .padding()
            .padding(.top, 16)
            .background(Colors.whiteAlfa)
            .cornerRadius(24)
            .padding(viewModel.isAuth ? 30 : 12)
            Image(uiImage: UIImage(named: colorScheme == .dark ? Images.Auth.background2 : Images.Auth.background1) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: viewModel.isAuth ? 0 : 6)
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isAuth)
        .fullScreenCover(isPresented: $viewModel.isTabViewShow) {
            if AuthService().currentUser?.uid == Accesses.adminUser {
                TabBar(viewModel: MainTabViewModel())
            } else {
                let mainTabBarVM = MainTabViewModel()
                TabBar(viewModel: mainTabBarVM)
            }
        }
        .alert(item: $viewModel.alertModel) { alertModel in
            return Alert(
                title: Text(alertModel.title ?? ""),
                message: Text(alertModel.message ?? ""),
                dismissButton: .default(Text(alertModel.buttons.first?.title ?? ""), action: alertModel.buttons.first?.action)
            )
        }
    }
}

//  AuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var mainTabVM: MainTabVM
    @ObservedObject var viewModel = AuthorizationVM()
    @Binding var currentTab: Int
    @State private var showCatalog = false
    @State private var showView = false

    var body: some View {
        ZStack{
            VStack {
                HStack {
                    CustomBackButton()
                    Spacer()
                }
                .padding([.leading, .top], 16)
                Spacer()
                AnimatedImagesView()
                Spacer()
                AuthorizationFieldsView(viewModel: viewModel, showCatalog: $showCatalog)
                    .padding(.horizontal)

                ForgotPasswordButton().createButton(action: {
                    showView.toggle()
                })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }

            if showView {
                ForgotPasswordView(isOpenView: $showView)
            }
        }

        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showCatalog) {
            TabBar(viewModel: mainTabVM)
                .onAppear {
                    mainTabVM.fetchUserId()
                }
        }
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
        .onChange(of: currentTab) { _, _ in
                dismiss()
        }
    }
}




//  AuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AuthorizationView: View {
    @EnvironmentObject var mainTabVM: MainTabVM
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = AuthorizationVM()
    @Binding var currentTab: Int
    @State private var isShowCatalog = false
    @State private var isShowView = false
    
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
                AuthorizationFieldsView(viewModel: viewModel, isShowCatalog: $isShowCatalog)
                    .padding(.horizontal)
                ForgotPasswordButton().createButton(action: {
                    isShowView.toggle()
                })
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            if isShowView {
                ForgotPasswordView(isOpenView: $isShowView)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.isShowCatalog) {
            TabBar(viewModel: mainTabVM)
                .onAppear {
                    mainTabVM.fetchUserId()
                }
        }
        .onTapGesture {
            self.hideKeyboard()
            UIApplication.shared.endEditing()
        }
        .onChange(of: currentTab) { oldValue, newValue in
            if oldValue != newValue {
                dismiss()
            }
        }
    }
}




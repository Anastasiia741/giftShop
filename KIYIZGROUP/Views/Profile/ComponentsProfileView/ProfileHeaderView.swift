//  ProfileHeaderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileHeaderView: View {
    @StateObject var viewModel: ProfileVM
    private let textComponent = TextComponent()

    var body: some View {
        VStack(spacing: 8) {
            Image("profile")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            textComponent.createText(text: viewModel.name.isEmpty ? "Имя пользователя" : viewModel.name, fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
            textComponent.createText(text: viewModel.email, fontSize: 16, fontWeight: .bold, lightColor: .gray, darkColor: .gray)
        }
        .onAppear {
            Task {
                await viewModel.fetchUserProfile()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}


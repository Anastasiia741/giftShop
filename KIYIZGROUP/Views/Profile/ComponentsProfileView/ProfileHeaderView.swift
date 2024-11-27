//  ProfileHeaderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileHeaderView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    let name: String
    let email: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image("profile")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            textComponent.createText(text: name.isEmpty ? "Имя пользователя" : name, fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
            
            textComponent.createText(text: email, fontSize: 16, fontWeight: .bold, color: .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}


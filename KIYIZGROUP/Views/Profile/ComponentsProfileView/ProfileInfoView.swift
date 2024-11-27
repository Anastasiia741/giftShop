//  ProfileInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileInfoView: View {
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
                   Button(action: {
                       print("О компании нажато")
                   }) {
                       HStack {
                        textComponent.createText(text: "О компании", fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
                           Spacer()
                           Image(systemName: "chevron.right")
                               .foregroundColor(.gray)
                       }
                       .padding()
                   }
                   .background(Color.clear)
                   
                   Divider()
                       .padding(.horizontal)
                       .background(Color.gray.opacity(0.5))
                   
                   Button(action: {
                       print("Контакты нажато")
                   }) {
                       HStack {
                           textComponent.createText(text: "Контакты", fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
                           Spacer()
                           Image(systemName: "chevron.right")
                               .foregroundColor(.gray)
                       }
                       .padding()
                   }
                   .background(Color.clear)
               }
               .background(
                   RoundedRectangle(cornerRadius: 12)
                       .stroke(Color.gray.opacity(0.3), lineWidth: 1)
               )
               .padding()
           }
    
}

#Preview {
    ProfileInfoView()
}

//  SupportInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/1/25.

import SwiftUI

struct SupportInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                UIApplication.openWebsite("https://mobimint.kg/")
            }) {
                HStack {
                    textComponent.createText(text: "Политика конфиденциальности", fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
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

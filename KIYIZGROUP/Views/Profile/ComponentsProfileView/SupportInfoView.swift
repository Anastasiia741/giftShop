//  SupportInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 10/1/25.

import SwiftUI

struct SupportInfoView: View {
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                UIApplication.openWebsite("https://mobimint.kg/")
            }) {
                HStack {
                    textComponent.createText(text: "Политика конфиденциальности", fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
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

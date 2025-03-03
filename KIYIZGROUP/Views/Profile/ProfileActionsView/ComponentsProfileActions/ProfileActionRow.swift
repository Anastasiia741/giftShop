//  ProfileActionRow.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/1/25.

import SwiftUI

struct ProfileActionRow: View {
    let title: String
    let subtitle: String
    let textComponent: TextComponent
    let showChevron: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                textComponent.createText(text: title, fontSize: 16, fontWeight: .bold, lightColor: .white, darkColor: .white)
                textComponent.createText(text: subtitle, fontSize: 14, fontWeight: .regular, lightColor: .white.opacity(0.8), darkColor: .white.opacity(0.8))
            }
            Spacer()
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
    }
}



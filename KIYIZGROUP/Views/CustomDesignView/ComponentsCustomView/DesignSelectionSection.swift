//  DesignSelectionSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 28/11/24.

import SwiftUI


struct DesignSelectionSection: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textComponent.createText(text: "Выберите дизайн", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                .padding(.bottom, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Design.allCases, id: \.self) { design in
                        Image(design.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .cornerRadius(10)
                    }
                }
            }

            Button(action: {
                print("Прикрепить фото нажато")
            }) {
                HStack {
                    textComponent.createText(text: "Прикрепить фото", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(Color.colorDarkBrown)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
}

enum Design: String, CaseIterable {
    case design1 = "bag"
    case design2 = "bag1"
    case design3 = "bag2"
    case design4 = "bag4"

    var imageName: String {
        switch self {
        case .design1: return "bag"
        case .design2: return "bag"
        case .design3: return "bag"
        case .design4: return "bag"
        }
    }
}

//  ImageSelectionButton.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 5/2/25.

import SwiftUI

struct ImagePickerButton: View {
    let title: String
    let action: () -> Void
    private let textComponent = TextComponent()
    
    var body: some View {
        Button(action: action) {
            HStack {
                textComponent.createText(text: title, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
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

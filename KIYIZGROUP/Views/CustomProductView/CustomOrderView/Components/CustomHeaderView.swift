//  CustomHeaderView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 24/2/25.

import SwiftUI

struct CustomHeaderView: View {
    private let textComponent = TextComponent()
    var title: String
    
    var body: some View {
        HStack{
            textComponent.createText(text: title, fontSize: 21, fontWeight: .bold, style: .headline,  lightColor: .black, darkColor: .white)
                .padding(.bottom, 4)
            Spacer()
        }
        .padding()
    }
}


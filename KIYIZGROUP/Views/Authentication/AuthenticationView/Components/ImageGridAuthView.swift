//  ImageGridAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct ImageGridAuthView: View {
    let imageNames: [String]
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 105)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 8)
    }
}

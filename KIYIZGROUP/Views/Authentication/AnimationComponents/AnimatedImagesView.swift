//  AnimatedImagesView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AnimatedImagesView: View {
    @State private var offset1: CGFloat = 0
    @State private var offset2: CGFloat = 0
    
    var body: some View {
        ZStack {
            ImageLayer(imageName: "vector-1", offset: $offset1, animationSpeed: 23, direction: .left)
            ImageLayer(imageName: "vector", offset: $offset2, animationSpeed: 23, direction: .right, yOffset: 40)
        }
        .frame(height: 300)
        .clipped()
    }
}


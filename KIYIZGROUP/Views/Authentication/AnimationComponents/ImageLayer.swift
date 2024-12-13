//  ImageLayer.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/12/24.

import SwiftUI

enum AnimationDirection {
    case left
    case right
}

struct ImageLayer: View {
    let imageName: String
    @Binding var offset: CGFloat
    let animationSpeed: CGFloat
    let direction: AnimationDirection
    let yOffset: CGFloat
    
    init(imageName: String, offset: Binding<CGFloat>, animationSpeed: CGFloat, direction: AnimationDirection, yOffset: CGFloat = 0) {
        self.imageName = imageName
        self._offset = offset
        self.animationSpeed = animationSpeed
        self.direction = direction
        self.yOffset = yOffset
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            HStack(spacing: 0) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth, height: 150)
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth, height: 150)
            }
            .offset(x: offset, y: yOffset)
            .onAppear {
                startAnimation(screenWidth: screenWidth)
            }
        }
    }
    
    private func startAnimation(screenWidth: CGFloat) {
        switch direction {
        case .left:
            offset = 0
            withAnimation(Animation.linear(duration: animationSpeed).repeatForever(autoreverses: false)) {
                offset = -screenWidth
            }
        case .right:
            offset = -screenWidth
            withAnimation(Animation.linear(duration: animationSpeed).repeatForever(autoreverses: false)) {
                offset = 0
            }
        }
    }
}


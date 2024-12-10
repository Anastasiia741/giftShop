//  AnimatedImagesView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct AnimatedImagesView: View {
    @State private var offset1: CGFloat = 0
    @State private var offset2: CGFloat = 0
    private let animationSpeed: CGFloat = 25
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                Image("vector-1")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .offset(x: offset1)
                    .onAppear {
                        offset1 = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(Animation.linear(duration: animationSpeed).repeatForever(autoreverses: false)) {
                                offset1 = -screenWidth
                            }
                        }
                    }
                Image("vector")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .offset(x: offset2, y: 40)
                    .onAppear {
                        offset2 = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(Animation.linear(duration: animationSpeed).repeatForever(autoreverses: false)) {
                                offset2 = screenWidth
                            }
                        }
                        
                    }
            }
        }
        .frame(height: 200)
        .clipped()
    }
}

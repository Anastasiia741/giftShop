//  ImageGridAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct ImageGridAuthView: View {
    let imageNames: [String]
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var rotationAngles: [Double] = []
    @State private var animationIndexOrder: [Int] = []
    @State private var currentIndex = 0
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(imageNames.indices, id: \.self) { index in
                Image(imageNames[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 105)
                    .cornerRadius(8)
                    .rotationEffect(.degrees(rotationAngles[safe: index] ?? 0))
                    .animation(.easeInOut(duration: 1), value: rotationAngles[safe: index] ?? 0)
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            initializeRotationAngles()
            setupAnimationOrder()
            startAnimation()
        }
    }
    
    private func initializeRotationAngles() {
        rotationAngles = Array(repeating: 0, count: imageNames.count)
    }
    
    private func setupAnimationOrder() {
        animationIndexOrder = Array(imageNames.indices).shuffled()
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            guard !animationIndexOrder.isEmpty else { return }
            let currentIndexInOrder = animationIndexOrder[currentIndex]
            rotationAngles[currentIndexInOrder] += 180
            currentIndex = (currentIndex + 1) % animationIndexOrder.count
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

//  ImageGridAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct ImageGridAuthView: View {
    let imageNames: [String]
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var rotationAngles: [Double] = []
    @State private var simultaneousAnimations = false
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(imageNames.indices, id: \.self) { index in
                Image(imageNames[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 105)
                    .cornerRadius(8)
                    .rotationEffect(.degrees(rotationAngles[safe: index] ?? 0))
                    .animation(.easeInOut(duration: 0.8), value: rotationAngles[safe: index] ?? 0)
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            initializeRotationAngles()
            startAnimation()
        }
    }
    
    private func initializeRotationAngles() {
        rotationAngles = Array(repeating: 0, count: imageNames.count)
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            if simultaneousAnimations {
                let indices = randomUniqueIndices(count: min(3, imageNames.count))
                for index in indices {
                    rotationAngles[index] += 360
                }
            } else {
                if let randomIndex = imageNames.indices.randomElement() {
                    rotationAngles[randomIndex] += 360
                }
            }
            simultaneousAnimations.toggle()
        }
    }

    private func randomUniqueIndices(count: Int) -> [Int] {
        let indices = Array(imageNames.indices).shuffled()
        return Array(indices.prefix(count))
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

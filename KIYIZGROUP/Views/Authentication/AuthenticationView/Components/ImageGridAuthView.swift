//  ImageGridAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

class AnimationTimer: ObservableObject {
    @Published var rotationAngles: [Double] = []
    private var currentIndex = 0
    private var timer: Timer?
    
    func startAnimation(for count: Int) {
        if rotationAngles.isEmpty {
            rotationAngles = Array(repeating: 0, count: count)
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            guard let self = self, !rotationAngles.isEmpty else { return }
            rotationAngles[currentIndex] += 180
            currentIndex = (currentIndex + 1) % rotationAngles.count
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

struct ImageGridAuthView: View {
    let imageNames: [String]
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    @StateObject private var animationTimer = AnimationTimer()
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(imageNames.indices, id: \.self) { index in
                Image(imageNames[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 105, height: 105)
                    .cornerRadius(8)
                    .rotationEffect(.degrees(animationTimer.rotationAngles[safe: index] ?? 0))
                    .animation(.easeInOut(duration: 1), value: animationTimer.rotationAngles[safe: index] ?? 0)
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            animationTimer.startAnimation(for: imageNames.count)
        }
        .onDisappear {
            animationTimer.stopAnimation()
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


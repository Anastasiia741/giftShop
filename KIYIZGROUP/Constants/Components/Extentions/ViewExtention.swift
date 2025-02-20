//  ViewExtention.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI
import Kingfisher

extension View {
    func productImageView(with url: URL?) -> some View {
        Group {
            if let url = url {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 140)
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 140)
                    .cornerRadius(16)
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func customTransition() -> some View {
        self.transition(.move(edge: .leading))
            .animation(.easeInOut(duration: 0.3), value: UUID())
    }
    
    func customTransition(isPresented: Binding<ActiveScreen?>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(1)
            .transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.1), value: isPresented.wrappedValue)
    }
    
    func customTransitions(isPresented: Binding<Bool?>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(1)
            .transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.1), value: isPresented.wrappedValue)
    }
    
    func customTransition(isPresented: Bool, from edge: Edge = .trailing) -> some View {
        self.modifier(CustomTransitionModifier(isPresented: isPresented, edge: edge))
    }
}



//  ViewExtention.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func customTransition() -> some View {
        self.transition(.move(edge: .leading))
            .animation(.easeInOut(duration: 0.3), value: UUID())
    }
}

extension View {
    func customTransition(isPresented: Binding<ActiveScreen?>) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(1)
            .transition(.move(edge: .trailing))
            .animation(.easeInOut(duration: 0.1), value: isPresented.wrappedValue)
    }
}

extension View {
    func customTransition(isPresented: Bool, from edge: Edge = .trailing) -> some View {
        self.modifier(CustomTransitionModifier(isPresented: isPresented, edge: edge))
    }
}



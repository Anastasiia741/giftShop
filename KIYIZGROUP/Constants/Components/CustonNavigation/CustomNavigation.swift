//  CustomNavigation.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI

struct CustomNavigation<Content: View, Destination: View>: View {
    @Binding var isActive: Bool
    let destination: Destination
    let content: Content
    let showBackButton: Bool
    
    init(
        isActive: Binding<Bool>,
        showBackButton: Bool = true,
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder content: () -> Content
    ) {
        self._isActive = isActive
        self.destination = destination()
        self.content = content()
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        ZStack {
            if isActive {
                ZStack(alignment: .topLeading) {
                    destination
                        .transition(.move(edge: .trailing))
                    if showBackButton {
                        CustomBackButton(onBack: {
                            withAnimation {
                                self.isActive = false
                            }
                        })
                        .padding()
                    }
                }
            } else {
                content
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isActive)

    }
}

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            if let onBack = onBack {
                onBack()
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            HStack {
                Image(systemName: Images.chevronLeft)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            }
        }
    }
    
    
    
    
}

struct CustomNavigationView<Content: View, Destination: View>: View {
    @Binding var isActive: Bool
    let destination: Destination
    let content: Content
    
    init(isActive: Binding<Bool>, @ViewBuilder destination: () -> Destination, @ViewBuilder content: () -> Content) {
        self._isActive = isActive
        self.destination = destination()
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isActive {
                destination
                    .transition(.move(edge: .trailing))
            } else {
                content
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}



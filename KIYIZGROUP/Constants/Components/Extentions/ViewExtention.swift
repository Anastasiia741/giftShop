//  ViewExtention.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI
import Kingfisher

//MARK: - Change color
struct ColorManager {
    static func adaptiveColor(light: Color, dark: Color) -> Color {
        let isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        return isDarkMode ? dark : light
    }
}

struct AdaptiveColor: ViewModifier {
    let lightColor: Color
    let darkColor: Color
    
    func body(content: Content) -> some View {
        content.foregroundColor(ColorManager.adaptiveColor(light: lightColor, dark: darkColor))
    }
}

struct AdaptiveStroke: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let lightColor: Color
    let darkColor: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        colorScheme == .dark ? darkColor : lightColor,
                        lineWidth: lineWidth
                    )
            )
    }
}

struct AdaptiveFill: ViewModifier {
    let lightColor: Color
    let darkColor: Color
    let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(colorScheme == .dark ? darkColor : lightColor)
            )
    }
}

extension View {
    func adaptiveForeground(light: Color, dark: Color) -> some View {
        self.modifier(AdaptiveColor(lightColor: light, darkColor: dark))
    }
    
    func adaptiveStroke(lightColor: Color = .gray, darkColor: Color = .white, lineWidth: CGFloat = 1.7, cornerRadius: CGFloat = 12) -> some View {
        self.modifier(AdaptiveStroke(lightColor: lightColor, darkColor: darkColor, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    func adaptiveFill(lightColor: Color = .white, darkColor: Color = .black, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(AdaptiveFill(lightColor: lightColor, darkColor: darkColor, cornerRadius: cornerRadius))
    }
}

//MARK: - RoundedRectangle
struct AdaptiveOverlay: ViewModifier {
    let lightColor: Color
    let darkColor: Color
    let lineWidth: CGFloat
    let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        colorScheme == .dark ? darkColor : lightColor,
                        lineWidth: lineWidth
                    )
            )
    }
}

struct UnifiedRoundedRectangle: View {
    var isError: Bool = false
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(isError ? Color.red : .gray, lineWidth: 1.5)
    }
}

extension View {
    func adaptiveOverlay(lightColor: Color = Color(UIColor.systemGray4), darkColor: Color = .gray, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(AdaptiveOverlay(lightColor: lightColor, darkColor: darkColor, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
    
    func roundedRectangle(width: CGFloat = 50, height: CGFloat = 50, cornerRadius: CGFloat = 8, color: Color = .gray.opacity(0.1)) -> some View {
        self
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color)
            )
    }
    
    func roundedBorder(cornerRadius: CGFloat = 40, borderColor: Color, lineWidth: CGFloat = 1.3) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: lineWidth)
        )
    }
}


//MARK: - Image
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
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 140)
                    .cornerRadius(16)
            }
        }
    }
}

//MARK: - Divider
struct CustomDivider: View {
    var body: some View {
        Divider()
            .frame(height: 1.7)
            .padding(.horizontal)
            .background(Color.gray)
    }
}

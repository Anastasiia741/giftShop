//  Extentions.swift
//  GiftShop
//  Created by Анастасия Набатова on 7/3/24.

import SwiftUI

enum TabType: Int {
    case catalog, cart, profile, auth, productsEdit, createProduct, orders, customOrders
}

struct CustomTransitionModifier: ViewModifier {
    let isPresented: Bool
    let edge: Edge

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .zIndex(isPresented ? 1 : 0)
            .offset(x: isPresented ? 0 : (edge == .leading ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width))
            .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
}

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

extension View {
    func adaptiveForeground(light: Color, dark: Color) -> some View {
        self.modifier(AdaptiveColor(lightColor: light, darkColor: dark))
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

extension View {
    func adaptiveStroke(lightColor: Color = .gray, darkColor: Color = .white, lineWidth: CGFloat = 1.7, cornerRadius: CGFloat = 12) -> some View {
        self.modifier(AdaptiveStroke(lightColor: lightColor, darkColor: darkColor, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}

//        .background(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1.5)
//
//        )


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
    func adaptiveFill(lightColor: Color = .white, darkColor: Color = .black, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(AdaptiveFill(lightColor: lightColor, darkColor: darkColor, cornerRadius: cornerRadius))
    }
}
//    .background(RoundedRectangle(cornerRadius: 8).fill(colorScheme == .dark ? Color.black : Color.white))
//

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

extension View {
    func adaptiveOverlay(lightColor: Color = Color(UIColor.systemGray4), darkColor: Color = .gray, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 8) -> some View {
        self.modifier(AdaptiveOverlay(lightColor: lightColor, darkColor: darkColor, lineWidth: lineWidth, cornerRadius: cornerRadius))
    }
}

//    .overlay(
//        RoundedRectangle(cornerRadius: 8)
//            .stroke(colorScheme == .dark ? Color.gray : Color(UIColor.systemGray4), lineWidth: 1)
//    )


extension View {
    @ViewBuilder
      func adaptiveTextColor(light: Color, dark: Color) -> some View {
          self.environment(\.colorScheme, .light)
              .foregroundColor(Environment(\.colorScheme).wrappedValue == .dark ? dark : light)
      }
}

//  ButtonsComponents.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import Foundation
import SwiftUI

struct DetailButton: View {
    private let textComponent = TextComponent()
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textComponent.createText(text: text, fontSize: 16, fontWeight: .regular, color: isSelected ? Color.white : Color.black)
                .padding(.horizontal, 16)
                .frame(minWidth: 80, maxWidth: .infinity, minHeight: 40)
                .background(isSelected ? .colorGreen : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? .colorGreen : Color.gray, lineWidth: 1.5)
                )
                .cornerRadius(20)
                .layoutPriority(1)
        }
    }
}


struct GreenButton: View {
    private let textComponent = TextComponent()
    let text: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(isDisabled ? Color.clear : .colorGreen)
                    .frame(height: 54)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(isDisabled ? Color.gray : Color.clear, lineWidth: 1.3)
                    )
                textComponent.createText(text: text, fontSize: 16, fontWeight: .regular, color: isDisabled ? .black : .white)
            }
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
        }
        .frame(height: 54)
        .padding(.horizontal)
        .padding(.top, 16)
        .disabled(isDisabled)
    }
}

struct CustomButton {
    private let textComponent = TextComponent()
    
    func createButton(text: String, fontSize: CGFloat, fontWeight: Font.Weight, color: Color, backgroundColor: Color, borderColor: Color, cornerRadius: CGFloat = 25, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            textComponent.createText(text: text, fontSize: fontSize, fontWeight: fontWeight, color: color)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1.3)
                )
        }
    }
}

struct CustomButtonLogIn {
    func createButton(foregroundColor: Color, backgroundColor: Color, borderColor: Color, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            Image(systemName: "chevron.right")
                .foregroundColor(isEnabled ? foregroundColor : .gray)
                .frame(width: 54, height: 54)
                .background(
                    Circle()
                        .fill(isEnabled ? backgroundColor : .clear)
                        .overlay(
                            Circle()
                                .stroke(borderColor, lineWidth: 1)
                        )
                )
        }
        .disabled(!isEnabled)
    }
}

struct ForgotPasswordButton {
    private let textComponent = TextComponent()
    
    func createButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            textComponent.createText(text: "Забыл пароль?", fontSize: 16, fontWeight: .regular, color: Color.colorLightBrown)
                .padding()
        }
    }
}

struct MinimalButton {
    private let textComponent = TextComponent()
    
    func createMinimalButton(text: String, fontSize: CGFloat, fontWeight: Font.Weight, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            textComponent.createText(text: text, fontSize: fontSize, fontWeight: fontWeight, color: color).underline()
        }
    }
}

//MARK: - Cart
struct FlashingCircleButton: View {
    @State private var isFlashing: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.colorDarkBrown, lineWidth: 2)
                .scaleEffect(isFlashing ? 1.2 : 1.0)
                .opacity(isFlashing ? 0.5 : 1.0)
            
            Circle()
                .fill(Color.colorDarkBrown)
                .padding(4)
        }
        .frame(width: 22, height: 22)
        .onTapGesture {
            withAnimation(Animation.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
                isFlashing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isFlashing = false
            }
        }
    }
}


//MARK: - Profile
struct RoundedPasswordButton: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack{
                textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
            }
            .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.gray, lineWidth: 1.3)
            )
        }
        
    }
}

struct RoundedButton: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.gray, lineWidth: 1.3)
                )
        }
    }
}

struct RoundedRedButton: View {
    private let textComponent = TextComponent()
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            textComponent.createText(text: title, fontSize: 14, fontWeight: .regular, color: .r)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.gray, lineWidth: 1.3)
                )
        }
    }
}

struct SectionHeader: View {
    private let textComponent = TextComponent()
    let title: String
    let showButton: Bool
    let action: (() -> Void)?
    
    var body: some View {
        HStack {
            textComponent.createText(text: title.uppercased(), fontSize: 14, fontWeight: .regular, color: .gray)
            Spacer()
            if showButton, let action = action {
                Button(action: action) {
                    textComponent.createText(text: "Save".uppercased(), fontSize: 14, fontWeight: .regular, color: .colorLightBrown)
                }
            }
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
}

struct RoundedField: View {
    let placeholder: String
    let borderColor: Color
    @Binding var text: String
    
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(borderColor, lineWidth: 1.3)
            )
            .frame(height: 50)
    }
}

//MARK: - ProductDetailView
struct ButtonComponents {
    private let textComponent = TextComponent()
    
    func createWhiteButton(text: String, isAddedToCart: Binding<Bool>, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            HStack {
                textComponent.createText(text: text, fontSize: 16, fontWeight: .regular, color: .black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: 54)
            
            .overlay(RoundedRectangle(cornerRadius: 40)
                .stroke(Color("ColorDarkBrown"), lineWidth: 1.5)
            )
            
        }
    }
    
    func createGreenButton(text: String,  count: Binding<Int>, isAddedToCart: Binding<Bool>, action: @escaping () -> Void) -> some View {
        VStack {
            if isAddedToCart.wrappedValue {
                HStack {
                    Button(action: {
                        if count.wrappedValue > 1 {
                            count.wrappedValue -= 1
                            action()
                        }
                        else {
                            isAddedToCart.wrappedValue = false
                            count.wrappedValue = 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                    }
                    
                    VStack{
                        textComponent.createText(text: "\(count.wrappedValue)", fontSize: 14, fontWeight: .regular, color: .white)
                        textComponent.createText(text: "В корзине", fontSize: 12, fontWeight: .regular, color: .white)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    Button(action: {
                        count.wrappedValue += 1
                        action()
                        
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.colorGreen)
                .cornerRadius(40)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            } else {
                Button(action: {
                    isAddedToCart.wrappedValue = true
                    action()
                }) {
                    textComponent.createText(text: text, fontSize: 16, fontWeight: .regular, color: .white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: 54)
                        .background(Color.colorGreen)
                        .cornerRadius(40)
                }
            }
        }
    }
    
    
    
    func createCustomStepper(position: Product, count: Binding<Int>, range: ClosedRange<Int>, action: @escaping () -> Void) -> some View {
        HStack {
            Button(action: {
                if count.wrappedValue > range.lowerBound {
                    count.wrappedValue -= 1
                    action()
                }
            }) {
                Image(systemName: "minus")
                    .foregroundColor(count.wrappedValue > range.lowerBound ? .black : .gray)
                    .frame(width: 22, height: 22)
                    .background(Color.clear)
            }
            .disabled(count.wrappedValue <= range.lowerBound)
            
            textComponent.createText(text: "\(count.wrappedValue)", fontSize: 16, fontWeight: .regular, color: .black)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                if count.wrappedValue < range.upperBound {
                    count.wrappedValue += 1
                    action()
                }
            }) {
                Image(systemName: "plus")
                    .foregroundColor(count.wrappedValue < range.upperBound ? .black : .gray)
                    .frame(width: 24, height: 24)
                    .background(Color.clear)
            }
            .disabled(count.wrappedValue >= range.upperBound)
        }
        .padding()
        .frame(width: 200, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 37)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    func createOrderButton(amount: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                textComponent.createText(text: "Оформить заказ", fontSize: 16, fontWeight: .regular, color: .white)
                
                textComponent.createText(text: "\(amount) сом", fontSize: 16, fontWeight: .regular, color: .white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.colorGreen)
            .cornerRadius(40)
        }
        .padding(.horizontal, 16)
    }
    
    func createOrdersButton(amount: String, isDisabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                textComponent.createText(text: "Заказать", fontSize: 16, fontWeight: .regular, color: .white)
                
                textComponent.createText(text: "\(amount) сом", fontSize: 16, fontWeight: .regular, color: .white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            .cornerRadius(40)
        }
        .padding(.horizontal, 16)
        .disabled(isDisabled)
    }
}


//  ButtonsComponents.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import Foundation
import SwiftUI

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
    
    func createOrdersButton(amount: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                textComponent.createText(text: "Заказать", fontSize: 16, fontWeight: .regular, color: .white)
                    
                textComponent.createText(text: "\(amount) сом", fontSize: 16, fontWeight: .regular, color: .white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.colorGreen)
            .cornerRadius(40)
        }
        .padding(.horizontal, 16)
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
                   } else {
                       presentationMode.wrappedValue.dismiss() // Используем стандартное поведение
                   }
               }) {
                   HStack {
                       Image(systemName: Images.chevronLeft)
                           .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                   }
               }
           }
}

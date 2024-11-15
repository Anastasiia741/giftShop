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
                                                // If the count is 1 and we press "-", we remove the item from the cart
                                                isAddedToCart.wrappedValue = false
                                                count.wrappedValue = 1 // Reset count when removing
                                                // Optionally: Add logic to remove the product from the cart
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
}

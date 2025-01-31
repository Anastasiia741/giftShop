//  Extentions.swift
//  GiftShop
//  Created by Анастасия Набатова on 7/3/24.

import SwiftUI

enum TabType: Int {
    case catalog, cart, profile, productsEdit, createProduct, orders
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


struct CustomScrollView<Content: View>: View {
    var showsIndicators: Bool = true
    var content: () -> Content
    
    var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            content()
                .padding() // Настройка отступов
        }
        .onTapGesture {
            UIApplication.shared.endEditing() // Скрываем клавиатуру при касании
        }
    }
}

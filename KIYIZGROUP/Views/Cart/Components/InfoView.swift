//  InfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct InfoView: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    @State private var offset: CGFloat = 1000
    @Binding var isOpenView: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
                .onTapGesture {
                    closeInfoDialog()
                }
            VStack {
                Image("check-fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color.greenButton)
                
                textComponent.createText(text: "Заказ оформлен", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
                    .padding()
                
                textComponent.createText(text: "Наш оператор в скором времени свяжется с вами для подтверждения заказа", fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                
                    .frame(maxWidth: .infinity)
                
                    .padding()
                
                
                
                Button(action: {
                    closeInfoDialog()
                }) {
                    textComponent.createText(text: "отлично", fontSize: 16, fontWeight:.regular, color: .white)
                        .frame(width: 302, height: 54)
                        .background(Color.colorGreen)
                        .foregroundColor(.black)
                        .cornerRadius(40)
                }
                .padding()
            }
            .frame(width: 300, height: 280)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(colorScheme == .dark ? Color.black.opacity(0.7) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
            .zIndex(1)
        }
    }
}


extension InfoView {
    func closeInfoDialog() {
        withAnimation(.easeInOut) {
            offset = 1000
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isOpenView = false
        }
    }
}

struct InfoDialog_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isOpenView: .constant(true))
    }
}
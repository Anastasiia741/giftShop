//  InfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct InfoView: View, InfoDialogHandling {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    private let customButton = CustomButton()
    @State private var offset: CGFloat = 1000
    var isOpenView: Binding<Bool>
    
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
                    .foregroundColor(.new)
                
                textComponent.createText(text: "order_placed".localized, fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
                    .padding()
                
                textComponent.createText(text: "our_operator_will_contact_you".localized, fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                customButton.createButton(text: "great".localized, fontSize: 16, fontWeight: .regular, color: .white, backgroundColor: .colorGreen, borderColor: .colorGreen) {
                    closeDialog()
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
    private func closeDialog() {
        withAnimation(.spring()) {
            offset = 1000
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            closeInfoDialog()
        }
    }
}


struct InfoDialog_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isOpenView: .constant(true))
    }
}

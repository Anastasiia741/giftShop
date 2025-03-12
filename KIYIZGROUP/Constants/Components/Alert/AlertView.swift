//  AlertView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 17/1/25.

import SwiftUI

struct AlertView: View, InfoDialogHandling {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    private let customButton = CustomButton()
    @State private var offset: CGFloat = 1000
    let title: String
    let okButton: String
    let canselButton: String
    let okButtonAction: (() -> Void)?
    var isOpenView: Binding<Bool>
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.closeInfoDialog()
                }
            VStack() {
                textComponent.createText(text: title, fontSize: 18, fontWeight: .bold, lightColor: .black, darkColor: .white)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                HStack{
                    customButton.createButton(text: okButton, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black, backgroundColor: .clear, borderColor: .gray.opacity(0.5), cornerRadius: 100, action: {
                        okButtonAction?()
                    })
                    customButton.createButton(text: canselButton, fontSize: 14, fontWeight: .regular, color: colorScheme == .dark ? .white : .black, backgroundColor: .clear,  borderColor: .gray.opacity(0.5), cornerRadius: 100, action: {
                        closeInfoDialog()
                    }
                    )
                }
                .frame(width: 273, height: 50)
                .padding(.bottom)
            }
            .frame(width: 300, height: 180)
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
        .ignoresSafeArea()
    }
}

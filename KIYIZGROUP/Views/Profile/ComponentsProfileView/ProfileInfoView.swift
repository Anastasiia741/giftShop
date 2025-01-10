//  ProfileInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                UIApplication.openWebsite("https://kiyizgroup.kg/?fbclid=PAZXh0bgNhZW0CMTEAAaZrqMJ3JG4WVxq3d5RE8Y_hN-if-AJf5k1v8tt5TM2TyoytfqGc1qELgGY_aem_AFfebXBzp9jkPkuNIRfgWQ")
            }) {
                HStack {
                    textComponent.createText(text: "О компании", fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .background(Color.clear)
            
            Divider()
                .padding(.horizontal)
                .background(Color.gray.opacity(0.5))
            
            NavigationLink(destination: ContactInfoView()) {
                HStack {
                    textComponent.createText(text: "Контакты", fontSize: 16, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .background(Color.clear)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    ProfileInfoView()
}


struct ContactInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            textComponent.createText(text: "ОСТАЛИСЬ ВОПРОСЫ?", fontSize: 22, fontWeight: .bold, color: colorScheme == .dark ? .white : .black)
            Divider()
                .padding(.horizontal)
                .background(Color.colorGreen)
            textComponent.createText(text: "Оставьте заявку или позвоните по телефону, указанному на сайте, чтобы получить бесплатную консультацию.", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.colorGreen)
                textComponent.createText(text: "+996 558 850 000", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
            }
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.colorGreen)
                textComponent.createText(text: "kiyizgroup@gmail.com", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black
                )
            }
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.colorGreen)
                VStack(alignment: .leading, spacing: 5) {
                    textComponent.createText(text: "ТЦ БетаСторес 1, Бишкек", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                    textComponent.createText(text: "83 Мамырова, Ош", fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

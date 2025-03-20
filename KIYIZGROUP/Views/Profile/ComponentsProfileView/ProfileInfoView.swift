//  ProfileInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/11/24.

import SwiftUI

struct ProfileInfoView: View {
    @StateObject private var viewModel = ProfileVM()
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                UIApplication.openWebsite("https://kiyizgroup.kg/?fbclid=PAZXh0bgNhZW0CMTEAAaZrqMJ3JG4WVxq3d5RE8Y_hN-if-AJf5k1v8tt5TM2TyoytfqGc1qELgGY_aem_AFfebXBzp9jkPkuNIRfgWQ")
            }) {
                HStack {
                    textComponent.createText(text: "about_company".localized, fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
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
                    textComponent.createText(text: "contacts".localized, fontSize: 16, fontWeight: .bold, lightColor: .black, darkColor: .white)
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
    private let textComponent = TextComponent()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            textComponent.createText(text: "any_questions".localized, fontSize: 22, fontWeight: .bold, lightColor: .black, darkColor: .white)
            Divider()
                .padding(.horizontal)
                .background(Color.colorGreen)
            textComponent.createText(text: "leave_request".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.colorGreen)
                textComponent.createText(text: "+996 558 850 000", fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
            }
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.colorGreen)
                textComponent.createText(text: "kiyizgroup@gmail.com", fontSize: 16, fontWeight: .regular,lightColor: .black, darkColor: .white)
            }
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.colorGreen)
                VStack(alignment: .leading, spacing: 5) {
                    textComponent.createText(text: "shopping_center_betastores".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    textComponent.createText(text: "mamyrova".localized, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
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

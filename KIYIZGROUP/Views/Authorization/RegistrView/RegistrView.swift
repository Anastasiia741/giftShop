//  RegistrView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/12/24.

import SwiftUI

struct RegistrView: View {
    var body: some View {
        VStack{
            Spacer()
            AnimatedImagesView()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())

    }
}

#Preview {
    RegistrView()
}

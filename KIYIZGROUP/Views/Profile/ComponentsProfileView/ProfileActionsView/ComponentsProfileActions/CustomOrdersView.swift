//  CustomOrdersView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/1/25.

import SwiftUI

struct CustomOrdersView: View {
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

#Preview {
    CustomOrdersView()
}

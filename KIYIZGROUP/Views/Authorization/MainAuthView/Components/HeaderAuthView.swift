//  HeaderAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct HeaderAuthView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image("logoLight")
                .resizable()
                .scaledToFit()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
    }
}

#Preview {
    HeaderAuthView()
}

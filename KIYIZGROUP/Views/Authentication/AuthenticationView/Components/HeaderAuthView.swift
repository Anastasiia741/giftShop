//  HeaderAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct HeaderAuthView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            Image(colorScheme == .light ? "logoLight" : "logoDark")
                .resizable()
                .scaledToFit()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 16)
    }
}

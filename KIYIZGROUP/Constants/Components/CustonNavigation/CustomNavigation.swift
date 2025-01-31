//  CustomNavigation.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: Images.chevronLeft)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BackButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                HStack {
                    Image(systemName: Images.chevronLeft)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

enum ProfileNavigation: Hashable {
    case editProfile
    case changePassword
}

//  CustomNavigation.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI

enum ProfileNavigation: Hashable {
    case editProfile
    case changePassword
}

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

struct CustomBackProfileButton: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



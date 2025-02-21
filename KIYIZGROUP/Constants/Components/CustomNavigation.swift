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

struct CustomBackProfileButton: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            if let action = action {
                action() // Используем кастомное действие, если оно передано
            } else {
                presentationMode.wrappedValue.dismiss() // Обычное закрытие экрана
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



enum ProfileNavigation: Hashable {
    case editProfile
    case changePassword
}

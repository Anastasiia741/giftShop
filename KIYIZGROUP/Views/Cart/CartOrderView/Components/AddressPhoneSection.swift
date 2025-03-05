//  AddressPhoneSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressPhoneSection: View {
    @StateObject private var cartVM = CartVM()
    @ObservedObject var profileVM = ProfileVM()
    private let textFieldComponent = TextFieldComponent()
    private let textComponent = TextComponent()
    @Binding var navigationPath: NavigationPath
    @Binding var isAddressValid: Bool
    @Binding var isPhoneValid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textComponent.createText(text: "Адрес и номер телефона", fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
            HStack {
                textComponent.createText(text: getAddress().isEmpty ? "Добавить адрес" : getAddress(), fontSize: 16, fontWeight: .medium, lightColor: .black, darkColor: .white)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    navigationPath.append(CartNavigation.addressInputView)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.colorDarkBrown)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24)
                .stroke(isAddressValid ? .gray : .r, lineWidth: 1.3))
            textFieldComponent.createTextField(placeholder: "+996", text: profileVM.authService.currentUser != nil ? $profileVM.phone : $cartVM.phone, keyboardType: .phonePad, borderColor: isPhoneValid ? .gray : .r)
        }
        .onAppear {
            loadUserData()
        }
        .onChange(of: profileVM.phone) { _, newValue in
            isPhoneValid = !newValue.isEmpty
            savePhoneData()
        }
    }
}

extension AddressPhoneSection {
    private func getAddress() -> String {
        return profileVM.authService.currentUser != nil ? profileVM.address : cartVM.address
    }
    
    private func loadUserData() {
        if profileVM.authService.currentUser == nil {
            cartVM.fetchGuestData()
        } else {
            Task {
                await profileVM.fetchUserProfile()
            }
        }
    }
    
    private func savePhoneData() {
        if profileVM.authService.currentUser == nil {
            UserDefaults.standard.set(profileVM.phone, forKey: "guestPhone")
        } else {
            Task {
                await profileVM.saveProfile()
            }
        }
    }
}

//  AddressPhoneSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressPhoneSection: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var cartVM = CartVM()
    @ObservedObject var profileVM = ProfileVM()
    private let textFieldComponent = TextFieldComponent()
    private let textComponent = TextComponent()
    @Binding var navigationPath: NavigationPath
    var isValidate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textComponent.createText(text: "address_and_phone_number".localized, fontSize: 21, fontWeight: .bold, style: .headline, lightColor: .black, darkColor: .white)
            HStack {
                textComponent.createText(text: getAddress().isEmpty ? "add_address".localized : getAddress(), fontSize: 16, fontWeight: .medium, lightColor: .black, darkColor: .white)
                    .foregroundColor(getAddress().isEmpty ? .gray : .primary)
                
                Spacer()
                
                Button(action: {
                    navigationPath.append(CartNavigation.addressInputView)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .colorLightBrown : .colorDarkBrown)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24)
                .stroke(isValidate && getAddress().isEmpty ? Color.red : .gray, lineWidth: 1.3))
            
            textFieldComponent.createTextField(placeholder: "+996", text: profileVM.authService.currentUser != nil ? $profileVM.phone : $cartVM.phone, keyboardType: .phonePad,  borderColor: isValidate && getPhone().isEmpty ? .red : .gray)
        }
        .onAppear {
            loadUserData()
        }
        .onChange(of: profileVM.phone) { _, newValue in
            savePhoneData()
        }
        .onChange(of: cartVM.phone) { _, newValue in
            savePhoneData()
        }
    }
}

extension AddressPhoneSection {
    private func getAddress() -> String {
        return profileVM.authService.currentUser != nil ? profileVM.address : cartVM.address
    }
    
    private func getPhone() -> String {
        return profileVM.authService.currentUser != nil ? profileVM.phone : cartVM.phone
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
            UserDefaults.standard.set(cartVM.phone, forKey: "guestPhone")
        } else {
            Task {
                await profileVM.saveProfile()
            }
        }
    }
}

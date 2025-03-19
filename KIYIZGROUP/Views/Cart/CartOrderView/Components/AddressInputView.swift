//  AddressInputView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressInputView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profileVM: ProfileVM
    @ObservedObject var cartVM: CartVM
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    private let customButton = CustomButton()
    @Binding var currentTab: Int
    @State private var showDropdown = false
    @State private var isSaving = false
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Dropdown(borderColor: isSaving && getSelectedCity().isEmpty ? .red : (colorScheme == .dark ? .white : .gray),
                         placeholder: getSelectedCity().isEmpty ? "select_city".localized : getSelectedCity(),
                         options: profileVM.cities,
                         selectedOption: profileVM.authService.currentUser != nil ? $profileVM.selectedCity : $cartVM.selectedCity,
                         isExpanded: $showDropdown)
                .padding(.vertical, 8)
                RoundedField(placeholder: "street_house".localized, borderColor: isSaving && getAddress().isEmpty ? .red : (colorScheme == .dark ? .white : .gray), text: profileVM.authService.currentUser != nil ? $profileVM.address : $cartVM.address)
                    .padding(.vertical, 8)
                RoundedField(placeholder: "apartment_number".localized, borderColor: colorScheme == .dark ? .white : .gray, text: profileVM.authService.currentUser != nil ? $profileVM.appatment : $cartVM.appatment)
                    .padding(.vertical, 8)
                RoundedField(placeholder: "floor_entrance".localized, borderColor: colorScheme == .dark ? .white : .gray, text: profileVM.authService.currentUser != nil ? $profileVM.floor : $cartVM.floor)
                    .padding(.vertical, 8)
                RoundedField(placeholder: "additional_comments".localized, borderColor: colorScheme == .dark ? .white : .gray, text: profileVM.authService.currentUser != nil ? $profileVM.comments : $cartVM.comments)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
            Spacer()
            customButton.createButton(text: "add_address".localized, fontSize: 16, fontWeight: .regular,
                                      color: getAddress().isEmpty || getSelectedCity().isEmpty ? .gray : .white,
                                      backgroundColor: getAddress().isEmpty || getSelectedCity().isEmpty ? Color.clear : Color.colorGreen,
                                      borderColor: getAddress().isEmpty || getSelectedCity().isEmpty ? .gray : .colorGreen) {
                isSaving = true
                guard !getSelectedCity().isEmpty, !getAddress().isEmpty else { return }
                saveAddress()
            }
                                      .padding(.bottom, 8)
        }
        .onChange(of: currentTab) { _, _ in
            dismiss()
        }
        
        .onAppear {
            if profileVM.authService.currentUser == nil {
                cartVM.fetchGuestData()
            }
        }
        .padding()
        .navigationTitle("your_delivery_address".localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

extension AddressInputView {
    private func getAddress() -> String {
        return profileVM.authService.currentUser != nil ? profileVM.address : cartVM.address
    }
    
    private func getSelectedCity() -> String {
        return profileVM.authService.currentUser != nil ? profileVM.selectedCity : cartVM.selectedCity
    }
    
    private func saveAddress() {
        if profileVM.authService.currentUser != nil {
            Task {
                await profileVM.saveProfile()
                dismiss()
            }
        } else {
            cartVM.saveGuestData()
            dismiss()
        }
    }
}



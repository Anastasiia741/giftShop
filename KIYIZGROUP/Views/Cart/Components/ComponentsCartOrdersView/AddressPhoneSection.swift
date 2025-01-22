//  AddressPhoneSection.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressPhoneSection: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ProfileVM
    private let textFieldComponent = TextFieldComponent()
    private let textComponent = TextComponent()
    @Binding var isAddressValid: Bool
    @Binding var isPhoneValid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            textComponent.createText(text: "Адрес и номер телефона", fontSize: 21, fontWeight: .bold, style: .headline, color: colorScheme == .dark ? .white : .black)
            HStack {
                textComponent.createText(text: viewModel.address.isEmpty ? "Добавить адрес" : viewModel.address, fontSize: 16, fontWeight: .medium, color: colorScheme == .dark ? .white : .black)
                    .foregroundColor(.gray)
                Spacer()
                NavigationLink(destination: AddressInputView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.colorDarkBrown)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24)
                    .stroke(isAddressValid ? .gray : .r, lineWidth: 1.3))
            textFieldComponent.createTextField(placeholder: "+996", text: $viewModel.phone, keyboardType: .phonePad, borderColor: isPhoneValid ? .gray : .r)
        }
        .onChange(of: viewModel.phone) { oldValue, newValue in
            isPhoneValid = !newValue.isEmpty
            Task {
                await viewModel.saveProfile()
            }
        }
    }
}

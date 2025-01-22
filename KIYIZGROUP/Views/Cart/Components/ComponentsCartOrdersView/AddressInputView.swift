//  AddressInputView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressInputView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileVM
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    private let customButton = CustomButton()
    @State private var showDropdown = false
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Dropdown(borderColor: isSaving && viewModel.selectedCity.isEmpty ? .red : .gray, placeholder: viewModel.selectedCity.isEmpty ? "Выберите город*" : viewModel.selectedCity, options: viewModel.cities, selectedOption: $viewModel.selectedCity, isExpanded: $showDropdown)
                        .padding(.vertical, 8)
                    RoundedField(placeholder: "Улица, Дом*", borderColor: isSaving && viewModel.address.isEmpty ? .red : .gray, text: $viewModel.address)
                        .padding(.vertical, 8)
                    RoundedField(placeholder: "Номер квартиры", borderColor: .gray, text: $viewModel.appatment)
                        .padding(.vertical, 8)
                    RoundedField(placeholder: "Этаж, подъезд", borderColor: .gray, text: $viewModel.floor)
                        .padding(.vertical, 8)
                    RoundedField(placeholder: "Дополнительные комментарии", borderColor: .gray, text: $viewModel.comments)
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
                Spacer()
                customButton.createButton(text: "Добавить адрес", fontSize: 16, fontWeight: .regular,
                                          color: viewModel.address.isEmpty || viewModel.selectedCity.isEmpty ? .gray : .white,
                                          backgroundColor: viewModel.address.isEmpty || viewModel.selectedCity.isEmpty ? Color.clear : Color.colorGreen,
                                          borderColor: viewModel.address.isEmpty || viewModel.selectedCity.isEmpty ? .gray : .colorGreen) {
                    isSaving = true
                    guard !viewModel.selectedCity.isEmpty, !viewModel.address.isEmpty else { return }
                    Task {
                        await viewModel.fetchUserProfile()
                        await viewModel.saveProfile()
                        dismiss()
                    }
                }
                 .padding(.bottom, 8)
            }
            .padding()
            .navigationTitle("Адрес доставки")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
        }
    }
}




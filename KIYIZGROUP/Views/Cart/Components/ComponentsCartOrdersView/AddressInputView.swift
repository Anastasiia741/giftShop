//  AddressInputView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 20/11/24.

import SwiftUI

struct AddressInputView: View {
    @Environment(\.dismiss) var dismiss
    private let textComponent = TextComponent()
    private let textFieldComponent = TextFieldComponent()
    let cities = ["Бишкек", "Ош", "Нарын", "Талас", "Баткен"]
    @State private var selectedCity: String = ""
    @State private var street: String = ""
    @State private var house: String = ""
    @State private var entrance: String = ""
    @State private var showDropdown: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Dropdown( placeholder: "Выберите город*", options: cities,selectedOption: $selectedCity, isExpanded: $showDropdown, borderColor: Color.gray.opacity(0.5))
                        .padding(.vertical, 8)
                    textFieldComponent.createTextField(placeholder:"Улица, микрорайон*", text: $street)
                        .textInputAutocapitalization(.words)
                        .padding(.vertical, 8)
                    textFieldComponent.createTextField(placeholder:"Дом*", text: $house)
                        .padding(.vertical, 8)
                    textFieldComponent.createTextField(placeholder:"Подъезд, домофон", text: $entrance)
                }
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    textComponent.createText(text: "Добавить адрес", fontSize: 16, fontWeight: .regular, color: .white)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorLightGray)
                        .cornerRadius(40)
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

struct Dropdown: View {
    let placeholder: String
    let options: [String]
    @Binding var selectedOption: String
    @Binding var isExpanded: Bool
    let borderColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedOption.isEmpty ? placeholder : selectedOption)
                        .foregroundColor(selectedOption.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1))
            }
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                        }
                        .background(Color.white)
                        if option != options.last {
                            Divider().padding(.horizontal)
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1))
            }
        }
    }
}


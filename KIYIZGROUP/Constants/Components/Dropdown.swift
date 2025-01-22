//  Dropdown.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 22/1/25.

import SwiftUI

struct Dropdown: View {
    var borderColor: Color = .gray
    let placeholder: String
    let options: [String]
    @Binding var selectedOption: String
    @Binding var isExpanded: Bool
    
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
                .background(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1.3))
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
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 24).stroke(borderColor, lineWidth: 1.3))
                .padding(.top, 8)
            }
            
        }
    }
}

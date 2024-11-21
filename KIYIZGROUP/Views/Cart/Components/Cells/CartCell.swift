//  PositionCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct CartCell: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel =  CartVM()
    private let textComponent = TextComponent()
    private let buttonComponents = ButtonComponents()

    @State private var count = 1
    @State private var imageURL: URL?
    @State private(set) var position: Product
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if let imageURL = imageURL {
                        WebImage(url: imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 134, height: 157)
                            .clipped()
                            .cornerRadius(16)
                            .shadow(radius: 4)
                    }
                }
                .padding(.leading, 40)
                VStack(alignment: .leading, spacing: 8) {
                    textComponent.createText(text: position.name, fontSize: 16, fontWeight: .regular, color: colorScheme == .dark ? .white : .black)
                        .padding(.bottom, 20)
                    buttonComponents.createCustomStepper(position: position, count: $count, range: 0...10) {
                        viewModel.updateProduct(position, count)
                        viewModel.fetchOrder()
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.gray)
                    .frame(width: 20, height: 20)
                   
            }
           
            .frame(width: 140)

            Divider()
                .padding(.horizontal)
                .background(Color.gray)
                     
            HStack {
                textComponent.createText(text: "\(viewModel.productCountMessage) \(Localization.som)", fontSize: 16, fontWeight: .heavy, color: .black)
                
                textComponent.createText(text: "\("1000") \(Localization.som)", fontSize: 16, fontWeight: .heavy, color: .gray).strikethrough()
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
                     
        }
        .frame(width: 372, height: 233)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1)
        )
        .onAppear {
            count = position.quantity
            if let productImage = position.image {
                let imageRef = Storage.storage().reference(forURL: productImage)
                imageRef.downloadURL { url, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let url = url {
                        DispatchQueue.main.async {
                            self.imageURL = url
                        }
                    }
                }
            }
        }
    }
}









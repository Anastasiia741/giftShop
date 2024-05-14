//  PopularProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 26/1/24.

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import SDWebImage

struct PopularProductCell: View {
    let product: Product
    @State private var imageURL: URL?
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageURL = imageURL {
                WebImage(url: imageURL)
                    .resizable()
                    .padding(.top, 10)
                    .frame(width: screen.width * 0.30, height: 130)
                    .scaledToFit()
                    .clipped()
                    .cornerRadius(16)
                    .padding(.top, -12)
            }
            VStack(spacing: 4) {
                HStack{
                    Text(product.name)
                        .customTextStyle(TextStyle.avenirRegular, size: 12)
                        .frame(height: 40)
                    Spacer()
                    Text("\(product.price) \(Localization.som)")
                        .customTextStyle(TextStyle.avenirBold, size: 12)
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 8)
            }
        }
        .frame(width: screen.width * 0.32, height:  screen.width * 0.4)
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 4)
        .onAppear {
            if let productImage = product.image {
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

#Preview {
    PopularProductCell(product: Product(id: 1,
                                        name: "Сумка",
                                        category: "",
                                        detail: "Большая сумка",
                                        price: 100,
                                        quantity: 1 ))
}

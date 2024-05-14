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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.width * 0.40, height: 120)
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
        .frame(width: screen.width * 0.40, height:  screen.width * 0.4)
        .background(Color.bg)
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


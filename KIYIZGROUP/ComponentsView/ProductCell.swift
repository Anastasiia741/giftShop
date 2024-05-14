//  ProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import SDWebImage

struct ProductCell: View {
    let product: Product
    @State private var imageURL: URL?
    @State private var name: String?
    @State private var category: String?
    @State private var price: Int?
    @State private var detail: String?

    var body: some View {
        VStack(spacing: 8) {
            if let imageURL = imageURL {
                WebImage(url: imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.width * 0.45, height: 150)
                    .clipped()
                    .cornerRadius(16)
                    .padding(.top, -12)
            }
            VStack(spacing: 4) {
                HStack{
                    Text(name ?? "")
                        .customTextStyle(TextStyle.avenirRegular, size: 14)
                        .frame(height: 40)
                    Spacer()
                    Text("\(price ?? 0) \(Localization.som)")
                        .customTextStyle(TextStyle.avenirBold, size: 14)
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 8)
            }
        }
        .frame(width: screen.width * 0.45, height:  screen.width * 0.5)
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
                            self.name = product.name
                            self.category = product.category
                            self.price = product.price
                            self .detail = product.detail
                        }
                    }
                }
            }
        }
    }
}

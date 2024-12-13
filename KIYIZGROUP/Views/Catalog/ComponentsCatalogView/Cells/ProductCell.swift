//  ProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI
import SDWebImage

struct ProductCell: View {
    @Environment(\.colorScheme) var colorScheme
    private let textComponent = TextComponent()
    @State private var imageURL: URL?
    @State private var name: String?
    @State private var category: String?
    @State private var price: Int?
    @State private var detail: String?
    let product: Product
    
    var body: some View {
        VStack() {
            if let imageURL = imageURL {
                WebImage(url: imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.width * 0.45, height: 150)
                    .clipped()
                    .cornerRadius(24)
            }
            VStack(alignment: .leading, spacing: 4) {
                textComponent.createText(text: name ?? "", fontSize: 12, fontWeight: .medium, color: colorScheme == .dark ? .white : .black)
                HStack {
                    textComponent.createText(text: "\(price ?? 0) \(Localization.som)", fontSize: 16, fontWeight: .heavy, color: colorScheme == .dark ? .white : .black)
                    textComponent.createText(text: "\("1000") \(Localization.som)", fontSize: 16, fontWeight: .heavy, color: .gray).strikethrough()
                }
            }
            .padding(.top, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(24)
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

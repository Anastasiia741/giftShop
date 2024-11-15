//  PopularProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 26/1/24.

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct PopularProductCell: View {
    private let textComponent = TextComponent()
    @State private var imageURL: URL?
    let product: Product
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(.colorDarkBrown)
                    .frame(width: 224, height: 224)
                    .position(x: 294, y: 102)
                VStack(alignment: .leading, spacing: 8) {
                    textComponent.createText(text: product.name, fontSize: 16, fontWeight: .bold, color: .white)
                        .padding(.top, 16)
                        .padding(.leading, 8)
                    textComponent.createText(text: "\(product.price) \(Localization.som)", fontSize: 16, fontWeight: .bold, color: .white)
                        .padding(.top, 22)
                        .padding(.leading, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 344, height: 129)
        .background(.colorLightBrown)
        .cornerRadius(24)
        .shadow(radius: 2)
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




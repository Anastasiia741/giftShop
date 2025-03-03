//  ProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import Kingfisher
import FirebaseStorage

struct ProductCell: View {
    private let textComponent = TextComponent()
    let product: Product
    @State private var imageURL: URL?
    
    var body: some View {
        VStack() {
            if let imageURL = imageURL {
                KFImage(imageURL)
                    .resizable()
                    .placeholder {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: screen.width * 0.45, height: 150)
                    }
                    .fade(duration: 0.3)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.width * 0.45, height: 150)
                    .clipped()
                    .cornerRadius(24)
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: screen.width * 0.45, height: 150)
                    .task {
                        await fetchImageURL()
                    }
            }
            VStack(alignment: .leading, spacing: 4) {
                textComponent.createText(text: product.name, fontSize: 12, fontWeight: .medium, lightColor: .black, darkColor: .white)
                HStack {
                    textComponent.createText(text: "\(product.price) \(Localization.som)", fontSize: 16, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                    textComponent.createText(text: "\("1000") \(Localization.som)", fontSize: 16, fontWeight: .heavy, lightColor: .gray, darkColor: .gray).strikethrough()
                                            
                }
            }
            .padding(.top, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(24)
    }
    
}


extension ProductCell {
    private func fetchImageURL() async {
        guard let imagePath = product.image, imagePath.hasPrefix("gs://") else {
            return
        }
        do {
            let url = try await Storage.storage().reference(forURL: imagePath).downloadURL()
            DispatchQueue.main.async {
                self.imageURL = url
            }
        } catch {
            print("Ошибка загрузки изображения: \(error.localizedDescription)")
        }
    }
}

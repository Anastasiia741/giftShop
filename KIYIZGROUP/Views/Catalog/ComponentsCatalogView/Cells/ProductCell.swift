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
                    .forceRefresh()
                    .cacheOriginalImage(false)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.width * 0.45, height: 150)
                    .clipped()
                    .cornerRadius(24)
                
            } else {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: screen.width * 0.45, height: 150)
                    .task {
                        fetchImage()
                    }
            }
            VStack(alignment: .leading, spacing: 4) {
                textComponent.createText(text: product.name, fontSize: 12, fontWeight: .medium, lightColor: .black, darkColor: .white)
                HStack {
                    textComponent.createText(text: "\(product.price) \(Localization.som)", fontSize: 16, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                    
                    fullPriceView()
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
    
    private func fetchImage() {
        guard let imagePath = product.image else { return }
        
        if let url = URL(string: imagePath), imagePath.starts(with: "https://") {
            self.imageURL = url
            return
        }
        
        if imagePath.starts(with: "gs://") {
            Storage.storage().reference(forURL: imagePath).downloadURL { url, error in
                if let error = error {
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.imageURL = url
                }
            }
        }
    }
    
    @ViewBuilder
    private func fullPriceView() -> some View {
        if let fullPrice = product.fullPrice, fullPrice > 0 {
            textComponent.createText(text: "\(fullPrice) \(Localization.som)", fontSize: 16, fontWeight: .heavy, lightColor: .gray, darkColor: .gray)
                .strikethrough()
        }
    }
}

extension URL {
    func appendingQueryParameter(_ name: String, value: String) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? self
    }
}

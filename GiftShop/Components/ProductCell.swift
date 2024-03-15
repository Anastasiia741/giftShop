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
                    Text(product.name)
                        .font(.custom(TextStyle.avenirRegular, size: 14))
                        .frame(height: 40)
                    Spacer()
                    Text("\(product.price) com")
                        .font(.custom(TextStyle.avenirBold, size: 14))
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 8)
            }
        }
        .frame(width: screen.width * 0.45, height:  screen.width * 0.5)
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


struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: Product(id: 1,
                                     name: "Сумка",
                                     category: "",
                                     detail: "Большая сумка",
                                     price: 100,
                                     quantity: 1 ))
    }
}

//  PositionCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import SwiftUI
import FirebaseStorage

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
                    productImageView(with: imageURL)
                }
                .padding(.leading)
                VStack(alignment: .leading) {
                    textComponent.createText(text: position.name, fontSize: 16, fontWeight: .regular, lightColor: .black, darkColor: .white)
                            .padding()
                    textComponent.createText(text: position.category.uppercased(), fontSize: 16, fontWeight: .regular, lightColor: .gray, darkColor: .white)
                            .padding()
                    buttonComponents.createCustomStepper(position: position, count: $count, range: 0...10, colorScheme: colorScheme) {
                        viewModel.updateProduct(position, count)
                        viewModel.fetchOrder()
                    }
                    .frame(width: 200)
                }
                .padding(.horizontal)
            }
            CustomDivider()
                     
            HStack {
                textComponent.createText(text: "\(position.price * count) \("som".localized)", fontSize: 16, fontWeight: .heavy, lightColor: .black, darkColor: .white)
                fullPriceView()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .frame(width: 370, height: 210)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 1.5)
        )
        .onAppear {
            setupViews()
        }
    }
}

extension CartCell {
    private func setupViews() {
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
    
    @ViewBuilder
    private func fullPriceView() -> some View {
        if let fullPrice = position.fullPrice, fullPrice > 0 {
            textComponent.createText(text: "\(fullPrice) сом", fontSize: 16, fontWeight: .heavy, lightColor: .gray, darkColor: .gray)
                .strikethrough()
        }
    }
}




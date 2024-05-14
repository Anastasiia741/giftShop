//  PositionCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 8/1/24.

import SwiftUI
import FirebaseStorage
import SDWebImageSwiftUI

struct CartCell: View {
    
    @StateObject var viewModel =  CartVM()
    @State private var count = 1
    @State private var imageURL: URL?
    @State private(set) var position: Product
    
    var body: some View {
        HStack {
            if let imageURL = imageURL {
                WebImage(url: imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screen.width * 0.20, height: screen.width * 0.20)
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 4)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(position.name)
                    .font(.headline)
                HStack {
                    Text("\(position.quantity) \(Localization.amount)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Stepper("", value: $count, in: 0...10) { _ in
                        viewModel.updateProduct(position, count)
                        viewModel.fetchOrder()
                    }
                    .labelsHidden()
                    .frame(width: 100)
                }
            }
        }
        .padding(.horizontal)
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

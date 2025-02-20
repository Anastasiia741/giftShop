//  CartOrdersCell.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 19/11/24.

import SwiftUI
import Kingfisher
import FirebaseStorage

struct CartOrdersCell: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel =  CartVM()
    private let textComponent = TextComponent()
    private let buttonComponents = ButtonComponents()
    @State private var count = 1
    @State private var imageURL: URL?
    @State private(set) var position: Product
    
    var body: some View {
        VStack{
        if let imageURL = imageURL {
            KFImage(imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 97, height: 111)
                        .clipped()
                        .cornerRadius(24)
                        .shadow(radius: 4)
            textComponent.createText(text: position.name, fontSize: 12, fontWeight: .thin, color: colorScheme == .dark ? .white : .black)
                    .padding(.bottom, 20)
            }
        }
        .padding(.vertical)
        .frame(width: 120, height: 134)
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








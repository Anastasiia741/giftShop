//  ProductDetailView.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    @ObservedObject var viewModel: ProductDetailVM
    @Environment(\.presentationMode) var presentationMode
    @State var count = 1
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                WebImage(url: viewModel.imageURL )
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 280)
                    .clipped()
                    .border(Color.gray, width: 2)
                    .cornerRadius(10)
                    .padding(.vertical, 8)
                    .onAppear {
                        viewModel.updateImageDetail()
                    }
            }
            .padding()
            VStack {
                HStack{
                    Text("\(viewModel.product.name)")
                        .font(.title.bold())
                    Spacer()
                    Text("\(viewModel.product.price) \(Localization.som)")
                        .font(.title)
                        .customTextStyle(TextStyle.avenirBold, size: 16)
                }.padding(.horizontal)
                
                ScrollView {
                    Text("\(viewModel.product.detail)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                HStack{
                    Stepper(value: $count, in: 1...100) {
                        Text("\(Localization.quantity) \(self.count)")
                    }
                }.padding([.horizontal, .bottom], 12)
                Button {
                    let product = Product(id: viewModel.product.id,
                                          name: viewModel.product.name,
                                          category: viewModel.product.category,
                                          detail: viewModel.product.detail,
                                          price: viewModel.product.price,
                                          image: viewModel.product.image,
                                          quantity: self.count)
                    viewModel.addProductToCart(product)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(Localization.add)
                        .padding()
                        .padding(.horizontal, 60)
                        .foregroundColor(Colors.brown)
                        .font(.title3.bold())
                        .background(LinearGradient(colors: [Colors.lightYellow, Colors.orange], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(30)
                }.padding(.bottom)
                Spacer()
            }
        }
    }
}


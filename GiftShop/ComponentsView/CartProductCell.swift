//  CartProductCell.swift
//  GiftShop
//  Created by Анастасия Набатова on 9/1/24.

import SwiftUI

struct CartProductCell: View {
   
    let product: Product
    
    var body: some View {
        VStack(spacing: 2) {
            Image("bag")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: screen.width * 0.45)
                .clipped()
                .cornerRadius(16)
            
            HStack{
                Text(product.title)
                    .font(.custom("AvenirNext-regular", size: 14))
                    .frame(height: 40)
                Spacer()
                Text("\(product.price) com")
                    .font(.custom("AvenirNext-bold", size: 14))
                
            }
            
            .padding(.horizontal, 6)
            .padding(.bottom, 6)
        }.frame(width: screen.width * 0.45, height:  screen.width * 0.5)
            .background(.white)
            .cornerRadius(16)
            .shadow(radius: 4)
    }
}

struct CartProductCell_Previews: PreviewProvider {
     static var previews: some View {
        PositionCell(position: Position(id: UUID().uuidString, product: Product(id: UUID().uuidString, title: "сумка", price: 2000, descript: ""), count: 3))
        
    }
}

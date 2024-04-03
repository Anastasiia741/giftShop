//  PromoCodeSheet.swift
//  GiftShop
//  Created by Анастасия Набатова on 10/1/24.

import SwiftUI

struct PromoCodeSheet: View {
    
    @ObservedObject var viewModel: CartVM
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            TextField("Enter Promo Code", text: $viewModel.promoCode)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Apply") {
//                    viewModel.applyPromoCode
                    isPresented = false
                }
                
                Button("Cancel") {
                    isPresented = false
                }
            }
            .padding()
        }
        .padding()
        .background(Color.red)
        .cornerRadius(10)
    }
    
    
    
}

struct PromoCodeSheet_Previews: PreviewProvider {
    
    static var previews: some View {
        CartView(viewModel: CartVM.shared)
        }
    
}

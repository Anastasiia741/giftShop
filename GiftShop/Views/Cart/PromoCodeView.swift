//  PromoCodeView.swift
//  GiftShop
//  Created by Анастасия Набатова on 6/5/24.

import SwiftUI

struct PromoCodeView: View {
    
    @StateObject private var viewModel = CartVM()
    @Binding var promo: String
    @Binding var isPromoSheetVisible: Bool
    
    var body: some View {
        ZStack(alignment: .top)  {
            Images.Cart.background6
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
            VStack(spacing: 8) {
                Spacer()
                if viewModel.promoResultText.isEmpty {
                    Text(Localization.unlockExclusiveDiscount)
                        .customTextStyle(TextStyle.avenirRegular, size: 20)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                } else {
                    Text(viewModel.promoResultText)
                        .customTextStyle(TextStyle.avenirRegular, size: 20)
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                }
                TextField(Localization.enterPromoCode, text: $promo)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                HStack(spacing: 16) {
                    Button(action: {
                        isPromoSheetVisible = false
                    }) {
                        Text(Localization.cancel)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Colors.promoCancel)
                            .cornerRadius(20)
                            .shadow(color: Colors.promoCancel.opacity(0.5), radius: 5, x: 10, y: 5)
                    }
                    Button(action: {
                        viewModel.promoCode = promo
                        viewModel.applyPromoCode()
                    }) {
                        Text(Localization.apply)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Colors.promoApply)
                            .cornerRadius(20)
                            .shadow(color: Colors.promoApply.opacity(0.5), radius: 5, x: 10, y: 5)
                    }
                }
                .padding()
            }
            .padding()
            .cornerRadius(10)
            .shadow(radius: 4)
        }.onAppear {
            viewModel.promoCode = ""
        }
    }
}

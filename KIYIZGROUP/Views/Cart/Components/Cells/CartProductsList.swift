//  CartProductsList.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 23/1/25.

import SwiftUI

struct CartProductsList: View {
    @ObservedObject var viewModel: CartVM
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.orderProducts) { product in
                    CartCell(viewModel: viewModel, position: product)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
        }
    }
}


//  ProductInfoView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 15/11/24.

import SwiftUI

struct ProductInfoView: View {
    private let textComponent = TextComponent()
    let productDetail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CurvedLineView()
            
            textComponent.createText(text: "about_product".localized, fontSize: 14, fontWeight: .regular, lightColor: .colorLightBrown, darkColor: .colorLightBrown)
                .padding(.horizontal, 16)
            
            ScrollView {
                textComponent.createText(text: "\(productDetail)", fontSize: 14, fontWeight: .regular, lightColor: .black, darkColor: .white)
                    .padding(.horizontal, 16)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.vertical)
        .cornerRadius(24)
        
    }
}

struct CurvedLineView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height: CGFloat = 2
                let curveHeight: CGFloat = 8
                
                path.move(to: CGPoint(x: 0, y: curveHeight))
                path.addQuadCurve(to: CGPoint(x: 20, y: height), control: CGPoint(x: 10, y: 0))
                path.addLine(to: CGPoint(x: width - 20, y: height))
                path.addQuadCurve(to: CGPoint(x: width, y: curveHeight), control: CGPoint(x: width - 10, y: 0))
            }
            .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
        }
        .frame(height: 10)
    }
}



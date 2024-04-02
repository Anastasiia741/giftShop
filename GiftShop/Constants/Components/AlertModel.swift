//  AlertModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 29/3/24.

import SwiftUI

struct AlertModel: Identifiable {
    @Binding var isShow: Bool
    let title: String?
    let message: String?
    let primaryButtonAction: (()->Void)?
    let secondaryButtonAction: (()->Void)?
    
    init(isShow: Binding<Bool>, title: String?, message: String? = nil, primaryButtonAction: (() -> Void)? = nil, secondaryButtonAction: (() -> Void)? = nil) {
        self._isShow = isShow
        self.title = title
        self.message = message
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
    }
    
    let id = UUID()
}


struct CustomAlert: View {
    var title: String
    var message: String
    
    var positiveButtonTitle: String?
    var negativeButtonTitle: String?
    
    private var positiveButtonAction: (() -> Void)?
    private var negativeButtonAction: (() -> Void)?
    
    init(title: String, message: String, positiveButtonTitle: String? = nil, negativeButtonTitle: String? = nil, positiveButtonAction: (() -> Void)? = nil, negativeButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.positiveButtonTitle = positiveButtonTitle
        self.negativeButtonTitle = negativeButtonTitle
        self.positiveButtonAction = positiveButtonAction
        self.negativeButtonAction = negativeButtonAction
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView()
                FooterView()
            }
            .frame(width: 270, height: 150)
            .background(Color.white)
            .cornerRadius(4)
        }
        .zIndex(2)
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
                .padding(.horizontal, 16)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    private func FooterView() -> some View {
        if let negativeButtonTitle = negativeButtonTitle, let positiveButtonTitle = positiveButtonTitle {
            HStack(spacing: 0) {
                Button(action: {
                    negativeButtonAction?()
                }) {
                    Text(negativeButtonTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(Color.white)
                
                Divider()
                    .frame(width: 0.5, height: 40)
                
                Button(action: {
                    positiveButtonAction?()
                }) {
                    Text(positiveButtonTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.pink)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(Color.white)
            }
        } else if let positiveButtonTitle = positiveButtonTitle {
            Button(action: {
                positiveButtonAction?()
            }) {
                Text(positiveButtonTitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.pink)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(Color.white)
        }
    }
}

extension CustomAlert {
    func onPositiveButtonTap(_ positiveButtonAction: (() -> Void)?) -> Self {
        var alert = self
        alert.positiveButtonAction = positiveButtonAction
        return alert
    }
    
    func onNegativeButtonTap(_ negativeButtonAction: (() -> Void)?) -> Self {
        var alert = self
        alert.negativeButtonAction = negativeButtonAction
        return alert
    }
}

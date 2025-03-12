//  ViewExtention.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI
import Kingfisher

extension View {
    func productImageView(with url: URL?) -> some View {
        Group {
            if let url = url {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 140)
                    .clipped()
                    .cornerRadius(16)
                    .shadow(radius: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 140)
                    .cornerRadius(16)
            }
        }
    }
}





import SwiftUI

extension View {
    func dismissView() {
        if let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController?.presentedViewController {
            root.dismiss(animated: true)
        } else {
            NotificationCenter.default.post(name: .dismissView, object: nil)
        }
    }
}

extension Notification.Name {
    static let dismissView = Notification.Name("dismissView")
}


extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func roundedBorder(cornerRadius: CGFloat = 40, borderColor: Color, lineWidth: CGFloat = 1.3) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: lineWidth)
        )
    }
}

struct CustomDivider: View {
    var body: some View {
        Divider()
            .frame(height: 1.7)
            .padding(.horizontal)
            .background(Color.gray)
        }
}

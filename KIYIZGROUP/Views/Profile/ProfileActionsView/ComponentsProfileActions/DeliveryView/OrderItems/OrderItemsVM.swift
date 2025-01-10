//  OrderItemsVM.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 9/1/25.

import Combine
import SwiftUICore
import FirebaseStorage

final class OrderItemsVM: ObservableObject {
    @Published var imageURLs: [String: URL] = [:]
    
    func fetchImage(for position: Position) {
        guard let productImage = position.image, imageURLs[position.id] == nil else {
            return
        }
        
        let imageRef = Storage.storage().reference(forURL: productImage)
        imageRef.downloadURL { [weak self] url, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
            } else if let url = url {
                DispatchQueue.main.async {
                    self?.imageURLs[position.id] = url
                }
            }
        }
    }
}

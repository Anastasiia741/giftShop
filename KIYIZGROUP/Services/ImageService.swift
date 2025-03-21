//  ImageLoaderService.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 21/2/25.

import Foundation
import FirebaseStorage

final class ImageService {
    static let shared = ImageService()
}

extension ImageService {
    func fetchImages(for order: CustomOrder, designImage: @escaping (String, URL?) -> Void, attachedImage: @escaping (String, URL?) -> Void) {
        if let designURLString = order.style?.image {
            fetchImageURL(from: designURLString) { url in
                DispatchQueue.main.async {
                    designImage(order.id, url)
                }
            }
        }
        
        if let attachedURLString = order.attachedImageURL {
            fetchImageURL(from: attachedURLString) { url in
                DispatchQueue.main.async {
                    attachedImage(order.id, url)
                }
            }
        }
    }
    
    private func fetchImageURL(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard !urlString.isEmpty else {
            completion(nil)
            return
        }
        
        let storageRef: StorageReference
        
        if urlString.hasPrefix("gs://") || urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            storageRef = Storage.storage().reference(forURL: urlString)
        } else {
            storageRef = Storage.storage().reference(withPath: urlString)
        }
        
        storageRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
}




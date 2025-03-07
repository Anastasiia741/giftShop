//  CustomProductVM.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 3/2/25.

import SwiftUI
import FirebaseStorage

final class CustomProductVM: ObservableObject {
    private let productService = CustomProductService()
    private let authService = AuthService()
    @Published var allCustomProducts: [CustomProduct] = []
    @Published var allCustomStyles: [CustomStyle] = []
    @Published var deisignURLs: [Int: URL] = [:]
    @Published var styleURLs: [Int: URL] = [:]
    @Published var selectedImage: UIImage?
    @Published var imageURL: URL?
    
    @Published var selectedProduct: CustomProduct?
    @Published var selectedStyle: CustomStyle?
    
    @Published var comment = ""
    @Published var phone = ""
    @Published var isShowConfirm = false
    
    @Published var showInfoView = false
    @Published var showOrderDetails = false
    
}

//MARK: - fetchProduct
extension CustomProductVM {
    func fetchCustomProduct() async {
        async let products = productService.fetchCustomProducts()
        async let styles = productService.fetchCustomStyles()
        
        do {
            let (fetchedProducts, fetchedStyles) = await (try products, try styles)
            
            await MainActor.run {
                self.allCustomProducts = fetchedProducts
                self.allCustomStyles = fetchedStyles
                self.fetchProductImages()
                self.fetchStyleImages()
            }
        } catch {
            print("Ошибка загрузки данных: \(error.localizedDescription)")
        }
    }
}

//MARK: - fetchImage
extension CustomProductVM {
    func fetchProductImages() {
        for product in allCustomProducts {
            if let productImage = product.image {
                let imageRef = Storage.storage().reference(forURL: productImage)
                imageRef.downloadURL { [weak self] url, error in
                    if let error = error {
                        print("Ошибка загрузки URL изображения: \(error.localizedDescription)")
                    } else if let imageURL = url {
                        DispatchQueue.main.async {
                            self?.deisignURLs[product.id] = imageURL
                        }
                    }
                }
            }
        }
    }
    
    func fetchStyleImages() {
        for product in allCustomStyles {
            if let styleImage = product.image {
                let imageRef = Storage.storage().reference(forURL: styleImage)
                imageRef.downloadURL { [weak self] url, error in
                    if let error = error {
                        print("Ошибка загрузки URL изображения: \(error.localizedDescription)")
                    } else if let imageURL = url {
                        DispatchQueue.main.async {
                            self?.styleURLs[product.id] = imageURL
                        }
                    }
                }
            }
        }
    }
}

//MARK: - 
extension CustomProductVM {
    @MainActor
    func loadSelectedDesignImage() async -> UIImage? {
        if let attachedImage = selectedImage {
            return attachedImage
        }
        return nil
    }

    @MainActor
    func loadStyleImage() async -> UIImage? {
        if let style = selectedStyle,
           let styleImageURL = styleURLs[style.id] {
            do {
                let (data, _) = try await URLSession.shared.data(from: styleImageURL)
                if let image = UIImage(data: data) {
                    return image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}



extension CustomProductVM {
    func submitOrder() async {
        guard !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Ошибка: Укажите номер телефона")
            return
        }
        
        guard selectedProduct != nil || selectedStyle != nil || selectedImage != nil else {
            print("Ошибка: Должен быть выбран хотя бы один параметр (тип товара, стиль или изображение)")
            return
        }
        
        var uploadedImageURL: String?
        
        if let selectedImage = selectedImage {
            do {
                uploadedImageURL = try await productService.uploadImageToStorage(image: selectedImage)
            } catch {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
            }
        }
        
        let currentUserID = authService.currentUser?.uid
        
        let newOrder = CustomOrder(
            userID: currentUserID ?? "guest_\(UUID().uuidString)",
            phone: phone,
            product: selectedProduct,
            style: selectedStyle,
            attachedImageURL: uploadedImageURL,
            additionalInfo: comment,
            date: Date()
        )
        
        do {
            try await productService.createOrder(newOrder)
            await MainActor.run {
                showInfoView = true
            }
            
            try await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                showInfoView = false
                showOrderDetails = true
            }
            
        } catch {
            print("Ошибка при отправке заказа: \(error.localizedDescription)")
        }
    }
}



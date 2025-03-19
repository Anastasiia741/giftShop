//  ProductDetailEditVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Foundation
import SwiftUI
import FirebaseStorage

final class ProductEditVM: ObservableObject {
    private let productsDB = ProductService()
    @Published var selectedProduct: Product?
    @Published var selectedImage: UIImage?
    @Published var imageURL: URL?
    @Published var alertTitle = ""
    @Published var alertModel: AlertModel?
    var onSaveCompletion: (() -> Void)?
    
    init(selectedProduct: Product ) {
        self.selectedProduct = selectedProduct
    }
}

//MARK: - Alert
extension ProductEditVM {
    private func configureAlertModel(with title: String) -> AlertModel {
        AlertModel(title: title, buttons: [AlertButtonModel(title: "Ок", action: { [weak self] in
            self?.alertModel = nil
            self?.onSaveCompletion?()
        }) ])
    }
    
    func showDeleteConfirmationAlert(onDelete: @escaping ()->Void) {
        alertModel = AlertModel(
            title: "Вы действительно хотите удалить товар?",
            buttons: [
                AlertButtonModel(title: "Да", action: { [weak self] in
                    self?.deleteProduct(onDelete: onDelete)
                }),
                AlertButtonModel(title: "Нет", action: { [weak self] in
                    self?.alertModel = nil
                })
            ]
        )
    }
}

//MARK: - Image
extension ProductEditVM {
    func updateImageDetail() {
        if let productImage = selectedProduct?.image {
            let imageRef = Storage.storage().reference(forURL: productImage)
            imageRef.downloadURL { [weak self] url, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let imageURL = url {
                        DispatchQueue.main.async {
                            self?.imageURL = imageURL
                        }
                    }
                }
            }
        }
    }
}

//MARK: - Product
extension ProductEditVM {
    func saveEditedProduct() {
        guard let selectedProduct = selectedProduct else { return }
        productsDB.update(product: selectedProduct) { [weak self] error in
            guard let self = self else { return }
            
            if error != nil {
                self.alertModel = self.configureAlertModel(with: error?.localizedDescription ?? "error")
                return
            }
            
            self.alertModel = self.configureAlertModel(with: "Данные успешно обновлены")
            
            guard let selectedImage = self.selectedImage, let imageURL = selectedProduct.image else { return }
            
            self.productsDB.updateImage(selectedImage, imageURL: imageURL) { [weak self] (updatedURL: String?, error: Error?) in
                guard let self = self else { return }
                
                if let updatedURL = updatedURL {
                    self.selectedProduct?.image = updatedURL
                } else {
                    self.alertModel = self.configureAlertModel(with:  error?.localizedDescription ?? "error")
                }
            }
        }
    }
    
    func deleteProduct(onDelete: @escaping () -> Void) {
        guard let product = selectedProduct else {
            return
        }
        productsDB.delete(product: product) { [weak self] error in
            if error != nil {
                self?.alertModel = self?.configureAlertModel(with:  error?.localizedDescription ?? "error")
            } else {
                self?.alertModel = AlertModel(title: "Товар успешно удален", message: nil, buttons: [
                    AlertButtonModel(title: "ok", action: {
                        onDelete()
                    })
                ])
            }
        }
    }
}

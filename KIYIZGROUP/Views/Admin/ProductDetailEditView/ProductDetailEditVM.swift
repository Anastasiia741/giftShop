//  ProductDetailEditVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 1/3/24.

import Foundation
import SwiftUI
import FirebaseStorage

final class ProductDetailEditVM: ObservableObject {
    
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
    
    private func configureAlertModel(with title: String) -> AlertModel {
        AlertModel(
            title: title,
            buttons: [
                AlertButtonModel(title: Localization.ok, action: { [weak self] in
                    self?.alertModel = nil
                    self?.onSaveCompletion?()
                    
                })
            ])
    }
    
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
    
    func saveEditedProduct() {
        guard let selectedProduct = selectedProduct else { return }
        productsDB.update(product: selectedProduct) { [weak self] error in
            if error != nil {
                self?.alertModel = self?.configureAlertModel(with: Localization.error)
            } else {
                self?.alertModel = self?.configureAlertModel(with: Localization.dataSavedSuccessfully)
                guard let selectedImage = self?.selectedImage, let imageURL = selectedProduct.image else { return }
                self?.productsDB.uploadImageToFirebase(selectedImage, imageURL) { [weak self] imageURL in
                    if let imageURL = imageURL {
                        self?.selectedProduct?.image = imageURL
                    } else {
                        self?.alertModel = self?.configureAlertModel(with: Localization.error)
                    }
                    
                }
            }
        }
    }
    
    func showDeleteConfirmationAlert(onDelete: @escaping ()->Void) {
        alertModel = AlertModel(
            title: Localization.deleteProduct,
            buttons: [
                AlertButtonModel(title: Localization.yes, action: { [weak self] in
                    self?.deleteProduct(onDelete: onDelete)
                }),
                AlertButtonModel(title: Localization.no, action: { [weak self] in
                    self?.alertModel = nil
                })
            ]
        )
    }
    
    func deleteProduct(onDelete: @escaping () -> Void) {
        guard let product = selectedProduct else {
            return
        }
        productsDB.delete(product: product) { [weak self] error in
            if error != nil {
                self?.alertModel = self?.configureAlertModel(with: Localization.error)
            } else {
                self?.alertModel = AlertModel(title: Localization.productRemoved, message: nil, buttons: [
                    AlertButtonModel(title: Localization.ok, action: {
                        onDelete()
                    })
                ])
            }
        }
    }
}

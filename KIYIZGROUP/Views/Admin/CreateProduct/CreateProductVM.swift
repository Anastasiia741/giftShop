//  CreateProductVM.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/2/24.

import Foundation
import SwiftUI
import Combine

final class CreateProductVM: ObservableObject {
    private var productService = ProductService()
    @Published var productImage: UIImage?
    @Published var imageURL: String?
    @Published var productName: String = ""
    @Published var productCategory: String = ""
    @Published var productPrice: String = ""
    @Published var productDetail: String = ""
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var alertModel: AlertModel?
    
}

//MARK: - create
extension CreateProductVM {
    private func createProduct(_ product: Product) {
        productService.create(product: product) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.alertModel = self.configureAlertModel(with: Localization.dataSavedSuccessfully, message: nil)
                    self.clearFields()
                }
            }
        }
    }
    
    func createNewProduct() {
        guard !productName.isEmpty, !productCategory.isEmpty, !productPrice.isEmpty, let selectedImage = productImage else {
            self.alertModel = configureAlertModel(with: Localization.attention, message: Localization.notFilledIn)
            return
        }
        productService.upload(image: selectedImage, url: productName) { [weak self] uploadedImageURL, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let uploadedImageURL = uploadedImageURL {
                    let newProduct = Product(
                        id: 0,
                        name: self.productName,
                        category: self.productCategory,
                        detail: self.productDetail,
                        price: Int(self.productPrice) ?? 0,
                        image: uploadedImageURL,
                        quantity: 1)
                    self.createProduct(newProduct)
                } else if let error = error {
                    self.alertModel = self.configureAlertModel(with: Localization.error, message: error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - errors
private extension CreateProductVM {
    func configureAlertModel(with title: String, message: String?) -> AlertModel {
        AlertModel(
            title: title,
            message: message,
            buttons: [
                AlertButtonModel(title: Localization.ok, action: { [weak self] in
                    self?.alertModel = nil
                })
            ])
    }
    
    func clearFields() {
        productName = ""
        productCategory = ""
        productPrice = ""
        productDetail = ""
        productImage = nil
    }
}

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
    @Published var name: String = ""
    @Published var category: String = ""
    @Published var price: String = ""
    @Published var fullPrice: String = ""
    @Published var detail: String = ""
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var alertModel: AlertModel?
    
    @Published var isImageValid: Bool = true
    @Published var isNameValid: Bool = true
    @Published var isCategoryValid: Bool = true
    @Published var isPriceValid: Bool = true
    @Published var isFullPriceValid: Bool = true
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
                    self.alertModel = self.configureAlertModel(with: "Данные успешно добавлены", message: nil)
                    self.clearFields()
                }
            }
        }
    }
    
    func createNewProduct() {
        guard validateFields() else {
            self.alertModel = configureAlertModel(with: "Внимание", message: "Не все поля заполнены")
            return
        }
        
        guard let selectedImage = productImage else {
            self.alertModel = configureAlertModel(with: "Внимание", message: "Изображение не выбрано")
            return
        }
        
        productService.uploadNewImage(selectedImage) { [weak self] uploadedImageURL, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.alertModel = self.configureAlertModel(with: "Ошибка", message: error.localizedDescription)
                    return
                }
                
                guard let uploadedImageURL = uploadedImageURL else {
                    self.alertModel = self.configureAlertModel(with: "Ошибка", message: "imageUploadFailed")
                    return
                }
                
                let newProduct = Product(id: 0,
                                         name: self.name,
                                         category: self.category,
                                         detail: self.detail,
                                         price: Int(self.price) ?? 0,
                                         fullPrice: Int(self.fullPrice) ?? 0,
                                         image: uploadedImageURL,
                                         quantity: 1)
                self.createProduct(newProduct)
            }
        }
    }
    
    func resetValidation() {
        isImageValid = true
        isNameValid = true
        isCategoryValid = true
        isPriceValid = true
        isFullPriceValid = true
    }
}

//MARK: - errors
private extension CreateProductVM {
    func validateFields() -> Bool {
        isImageValid = productImage != nil
        isNameValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
        isCategoryValid = !category.trimmingCharacters(in: .whitespaces).isEmpty
        isPriceValid = !price.trimmingCharacters(in: .whitespaces).isEmpty && Int(price) != nil
        isFullPriceValid = !fullPrice.trimmingCharacters(in: .whitespaces).isEmpty && Int(fullPrice) != nil
        
        return isImageValid && isNameValid && isCategoryValid && isPriceValid && isFullPriceValid
    }
    
    func configureAlertModel(with title: String, message: String?) -> AlertModel {
        AlertModel(title: title, message: message, buttons: [AlertButtonModel(title: "Ок", action: { [weak self] in
            self?.alertModel = nil})])
    }
    
    func clearFields() {
        name = ""
        category = ""
        price = ""
        fullPrice = ""
        detail = ""
        productImage = nil
    }
}

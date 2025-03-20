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
    @Published var nameRu: String = ""
    @Published var categoryRu: String = ""
    @Published var detailRu: String = ""
    
    @Published var nameEn: String = ""
    @Published var categoryEn: String = ""
    @Published var detailEn: String = ""
    
    @Published var nameKg: String = ""
    @Published var categoryKg: String = ""
    @Published var detailKg: String = ""
    
    @Published var price: String = ""
    @Published var fullPrice: String = ""
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
                self.alertModel = self.configureAlertModel(with: "Ошибка", message: error.localizedDescription)
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
                                         name: ["ru": self.nameRu, "en": self.nameEn, "ky-KG" : self.nameKg],
                                         category: ["ru": self.categoryRu, "en": self.categoryEn, "ky-KG" : self.categoryKg],
                                         detail: ["ru": self.detailRu, "en": self.detailEn, "ky-KG" : self.detailKg],
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



extension Product {
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": [
                "ru": name["ru"] ?? "",
                "en": name["en"] ?? "",
                "ky": name["ky"] ?? ""
            ],
            "category": [
                "ru": category["ru"] ?? "",
                "en": category["en"] ?? "",
                "ky": category["ky"] ?? ""
            ],
            "detail": [
                "ru": detail["ru"] ?? "",
                "en": detail["en"] ?? "",
                "ky": detail["ky"] ?? ""
            ],
            "price": price,
            "fullPrice": fullPrice ?? 0,
            "image": image ?? "",
            "quantity": quantity
        ]
    }
}

//MARK: - errors
private extension CreateProductVM {
    func validateFields() -> Bool {
        isImageValid = productImage != nil
        isNameValid = !nameRu.trimmingCharacters(in: .whitespaces).isEmpty || !nameEn.trimmingCharacters(in: .whitespaces).isEmpty || !nameKg.trimmingCharacters(in: .whitespaces).isEmpty
        isCategoryValid = !categoryRu.trimmingCharacters(in: .whitespaces).isEmpty || !categoryEn.trimmingCharacters(in: .whitespaces).isEmpty || !categoryKg.trimmingCharacters(in: .whitespaces).isEmpty
        isPriceValid = !price.trimmingCharacters(in: .whitespaces).isEmpty && Int(price) != nil
        isFullPriceValid = !fullPrice.trimmingCharacters(in: .whitespaces).isEmpty && Int(fullPrice) != nil
        
        return isImageValid && isNameValid && isCategoryValid && isPriceValid && isFullPriceValid
    }
    
    func configureAlertModel(with title: String, message: String?) -> AlertModel {
        AlertModel(title: title, message: message, buttons: [AlertButtonModel(title: "Ок", action: { [weak self] in
            self?.alertModel = nil})])
    }
    
    func clearFields() {
        nameRu = ""
        categoryRu = ""
        detailRu = ""
        nameEn = ""
        categoryEn = ""
        detailEn = ""
        nameKg = ""
        categoryKg = ""
        detailKg = ""
        price = ""
        fullPrice = ""
        detailRu = ""
        productImage = nil
    }
}

//  Products.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import Foundation
import FirebaseFirestore

final class Product: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.price == rhs.price && lhs.quantity == rhs.quantity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @DocumentID var documentID: String?
    var id = UUID().hashValue
    var name: [String: String]
    var category: [String: String]
    var detail: [String: String]
    var price: Int
    var fullPrice: Int?
    var image: String?
    var quantity: Int = 1
    
    var imageURL: URL? {
        guard let image = image else { return nil }
        if image.hasPrefix("gs://") {
            return nil
        }
        return URL(string: image)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, category, detail, price, fullPrice, image, quantity
    }
    
    init(id: Int, name: [String: String], category: [String: String], detail: [String: String], price: Int, fullPrice: Int, image: String? = nil, quantity: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.detail = detail
        self.price = price
        self.fullPrice = fullPrice
        self.image = image
        self.quantity = quantity
    }
    
}


extension Product {
    func localizedValue(for key: [String: String]) -> String {
        var currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        if currentLanguage == "ky-KG" {
            currentLanguage = "ky"
        }
        
        if let localizedText = key[currentLanguage], !localizedText.isEmpty {
            return localizedText
        }
        
        if let russianText = key["ru"], !russianText.isEmpty {
            return russianText
        }
        
        if let englishText = key["en"], !englishText.isEmpty {
            return englishText
        }
        
        return "—"
    }
}


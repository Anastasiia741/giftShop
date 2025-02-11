//  Images.swift
//  GiftShop
//  Created by Анастасия Набатова on 14/3/24.

import Foundation
import SwiftUI

enum AuthImages {
    static let imageNames: [String] = [
        "Frame 59", "Frame 60", "Frame 61", "Frame 62", "Frame 63", "Frame 64", "Frame 65", "Frame 66", "Frame 67"]
}

// ----------
enum Images {
    static let chevronLeft = "chevron.left"
    
    enum TabBar {
        static let order = Image(systemName: "tray.full")
        static let customOrder = Image(systemName: "list.bullet.rectangle")
    
        static let createProduct = Image(systemName: "plus.circle")
        static let productEdit = Image(systemName: "doc.text")
        static let menu = Image(systemName: "menucard")
        static let cart = Image(systemName: "cart")
        static let profile = Image(systemName: "person.circle")
    }
        
    enum Orders {
        static let exit = Image(systemName: "rectangle.portrait.and.arrow.right.fill")
    }
    
    enum Menu {
        static let chevron = Image(systemName: "chevron.right")
       


    }

    enum CreateProduct {
        static let image = UIImage(named: "photo")
    }
    
    enum Cart {
        static let emptyCart = Image("emptyCartImage")
        static let happyCart = Image("happyCart")
        static let background4 = Image("background4")
        static let vector = Image("vector-1")
    }
    
    enum Profile {
        static let emptyList = Image("emptyOrdersImage")
        static let exit = Image(systemName: "rectangle.portrait.and.arrow.forward")
    }
    
    enum Auth {
        static let background1 = "authScreen1"
        static let background2 = "authScreen2"
    }
}

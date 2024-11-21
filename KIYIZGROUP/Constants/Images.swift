//  Images.swift
//  GiftShop
//  Created by Анастасия Набатова on 14/3/24.

import Foundation
import SwiftUI

enum Images {
    static let chevronLeft = "chevron.left"
    
    enum TabBar {
        static let order = Image(systemName: "list.bullet")
        static let createProduct = Image(systemName: "plus.circle")
        static let productEdit = Image(systemName: "square.and.pencil")
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
        static let background6 = Image("background6")
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

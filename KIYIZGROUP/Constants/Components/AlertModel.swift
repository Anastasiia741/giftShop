//  AlertModel.swift
//  GiftShop
//  Created by Анастасия Набатова on 29/3/24.

import SwiftUI

struct AlertButtonModel {
    let title: String
    let action: (()->Void)?
}

struct AlertModel: Identifiable {
    let id = UUID()
    let title: String?
    let message: String?
    let buttons: [AlertButtonModel]
    
    init(title: String?, message: String? = nil, buttons: [AlertButtonModel]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}


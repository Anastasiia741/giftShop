//  Constants.swift
//  GiftShop
//  Created by Анастасия Набатова on 23/1/24.

import Foundation

enum TextMessage {
    static let empty = ""
    
    enum Menu {
        static let porularProducts = "барсетка"
    }
    
    enum Cart {
        static let descriptionMain = "Введите описание для главного экрана"
        static let descriptionDetail = "Введите подробное описание"
        static let cardMessade = "Заказ успешно отправлен. Сумма заказа:"
        static let cardEmpty = "Ваша корзина пока пуста"
        static let cardOrder = "Мы уже готовим ваш заказ. Ожидайте 🌺"
    }
    
    enum Authorization {
        static let policy = "https://ilten.github.io/app-policy/"
    }
}

enum TextStyle {
    static let avenir = "AvenirNext"
    static let avenirRegular = "AvenirNext-regular"
    static let avenirBold = "AvenirNext-bold"
}

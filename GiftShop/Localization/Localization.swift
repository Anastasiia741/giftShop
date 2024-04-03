//  Localozation.swift
//  GiftShop
//  Created by Анастасия Набатова on 19/3/24.

import Foundation

struct Localization {
    //MARK: - Auth
    static let emptyString = "empty_string".localized
    static let enterEmail = "enter_email".localized
    static let enterPassword = "enter_password".localized
    static let repeatPassword = "repeat_password".localized
    static let authorization = "authorization".localized
    static let registration = "registration".localized
    static let alreadyHaveAccount = "already_have_an_account".localized
    //MARK: - OrderDetail
    static let orderDetails = "order_details".localized
    static let orderDate = "order_date".localized
    static let status = "status".localized
    static let promoCode = "promo_code".localized
    static let goods = "goods".localized
    static let title = "title".localized
    static let amount = "amount".localized
    static let sum = "sum".localized
    static let som = "som".localized
    static let name = "name".localized
    static let email = "email".localized
    static let deliveryAddress = "delivery_address".localized
    static let phoneNumber = "phone_number".localized
    //MARK: - ProductDetailEditView
    static let productName = "product_name".localized
    static let enterProductName = "enter_product_name".localized
    static let category = "category".localized
    static let enterCategory = "enter_category".localized
    static let price = "price".localized
    static let enterPrice = "enter_price".localized
    static let detailedProductDescrip = "detailed_product_descrip".localized
    static let delete = "delete".localized
    static let save = "save".localized
    //MARK: - CreateProductView
    static let image = "image".localized
    static let description = "description".localized
    //MARK: - OrderCell
    static let dateOf = "date_of".localized
    static let moreDetails = "more_details".localized
    //MARK: - CatalogView
    static let popular = "popular".localized
    static let products = "products".localized
    //MARK: - ProductDetailView
    static let quantity = "quantity".localized
    static let add = "add".localized
    //MARK: - CartView
    static let cart = "cart".localized
    static let emptyСart = "empty_cart".localized
    static let addItemsToCart = "add_items_to_cart".localized
    static let addToOrder = "add_to_order".localized
    //TASK: - add messages
    static let cardMessage = "order_sent_successfully".localized
    static let cardEmpty = "your_cart_is_empty".localized
    static let cardOrder = "we_preparing_order".localized
    //
    static let getDiscount = "get_discount".localized
    static let total = "total".localized
    static let order = "order".localized
    static let unlockExclusiveDiscount = "unlock_exclusive_discount".localized
    static let enterPromoCode = "enter_promo_code".localized
    static let cancel = "cancel".localized
    static let apply = "apply".localized
    static let discount10 = "10%_discount".localized
    static let discount20 = "20%_discount".localized
    static let discount30 = "30%_discount".localized
    static let codeDoesNotExist = "code_does_not_exist".localized
    //MARK: - ProfileView
    static let profile = "profile".localized
    static let yourName = "your_name".localized
    static let enterYourName = "enter_your_name".localized
    static let enterPhoneNumber = "enter_phone_number".localized
    static let yourEmail = "your_email".localized
    static let yourDeliveryAddress = "your_delivery_address".localized
    static let enterYourDeliveryAddress = "your_delivery_address".localized
    static let yourFutureOrders = "your_future_orders".localized
    static let noOrdersYet = "no_orders_yet".localized
    static let yourOrders = "your_orders".localized
    static let deleteAccountName = "delete_account".localized
    //MARK: - Alerts
    static let registrationError = "registration_error".localized
    static let passwordMismatch = "password_mismatch".localized
    static let deleteProduct = "delete_product".localized
    static let yes = "yes".localized
    static let no = "no".localized
    static let dataSavedSuccessfully = "data_saved_successfully".localized
    static let ok = "ok".localized
    static let selectPhotoSource = "select_photo_source".localized
    static let gallery = "gallery".localized
    static let camera = "camera".localized
    static let deleteAccount = "delete_account".localized
    static let dataSuccessfullySaved = "data_successfully_saved".localized
    static let logOut = "log_out".localized
    static let goOut = "go_out".localized
    static let error = "error".localized
    static let attention = "attention".localized
    static let congratulations = "congratulations".localized
    static let notFilledIn = "not_filled_in".localized
    static let selectOrderStatus = "select_order_status".localized
    static let deleteYourAccount = "delete_your_account".localized
    static let accountDeleted = "account_deleted".localized
}

private extension String {
    
    var localized: String {
        NSLocalizedString(self,
                          tableName: nil,
                          bundle: Bundle.main,
                          value: "",
                          comment: "")
    }
}

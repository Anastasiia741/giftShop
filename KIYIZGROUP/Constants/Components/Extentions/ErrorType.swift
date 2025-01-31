//  ErrorType.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 27/1/25.

import Foundation

enum ErrorType {
    case email
    case password
    case general
}

enum ErrorTypeProfile: Identifiable {
    case dataSuccessfullySaved
    case profileFetchFailed
    case profileSaveFailed
    case profileNotLoaded
    case orderFetchFailed
    case accountDeletionFailed
    case logoutFailed

    var id: String {
        String(describing: self)
    }

    var message: String {
        switch self {
        case .dataSuccessfullySaved:
            return "Данные успешно сохранены."
        case .profileFetchFailed:
            return "Не удалось загрузить профиль."
        case .profileSaveFailed:
            return "Не удалось сохранить профиль."
        case .profileNotLoaded:
            return "Профиль не загружен."
        case .orderFetchFailed:
            return "Ошибка при загрузке заказов."
        case .accountDeletionFailed:
            return "Ошибка при удалении аккаунта."
        case .logoutFailed:
            return "Не удалось выйти из системы."
        }
    }
}


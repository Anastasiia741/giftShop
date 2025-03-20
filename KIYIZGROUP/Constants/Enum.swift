//  Enum.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 5/3/25.

import Foundation

enum CartNavigation: Hashable {
    case cartOrderView
    case orderDetailsView(Order)
    case addressInputView
}

enum LanguageTab: String, CaseIterable, Identifiable {
    case ru = "ру"
    case inl = "en"
    case kyrg = "кырг"
    
    var id: String { self.rawValue }
}

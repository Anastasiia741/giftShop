//  Enum.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 5/3/25.

import Foundation

enum CartNavigation: Hashable {
    case cartOrderView
    case orderDetailsView(Order)
    case addressInputView
}

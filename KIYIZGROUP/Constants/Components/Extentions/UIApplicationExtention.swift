//  UIApplicationExtention.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 13/1/25.

import SwiftUI

extension UIApplication {
    func endEditing() {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIApplication {
    static func openWebsite(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Некорректный URL")
            return
        }
        shared.open(url, options: [:], completionHandler: nil)
    }
}


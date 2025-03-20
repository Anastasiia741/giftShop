//  HeaderAuthView.swift
//  KIYIZGROUP
//  Created by Анастасия Набатова on 8/12/24.

import SwiftUI

struct LanguageToggleAuthView: View {
    @ObservedObject var languageManager = LanguageManager.shared
    private let textComponent = TextComponent()
    
    var body: some View {
        Button(action: {
            languageManager.toggleLanguage()
            
        }) {
            textComponent.createText(text: languageManager.selectedLanguage, fontSize: 16, fontWeight: .regular, lightColor: .colorLightBrown, darkColor: .colorLightBrown)
        }
    }
}


class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @AppStorage("selectedLanguage") private var storedLanguage: String = "ru" {
        didSet {
            let newLanguageCode = languageMap[storedLanguage] ?? "ru"
            Bundle.setLanguage(newLanguageCode)
            
            selectedLanguage = reverseLanguageMap[newLanguageCode] ?? "ru"
            
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    @Published var selectedLanguage: String
    
    let availableLanguages = ["EN", "KG", "РУ"]
    
    private let languageMap: [String: String] = [
        "EN": "en",
        "KG": "ky-KG",
        "РУ": "ru"
    ]
    
    private let reverseLanguageMap: [String: String] = [
        "en": "EN",
        "ky-KG": "KG",
        "ru": "РУ"
    ]
    
    init() {
        let initialLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        let uiLanguage = reverseLanguageMap[initialLanguage] ?? "ru"
        
        self.selectedLanguage = uiLanguage
        
        Bundle.setLanguage(languageMap[uiLanguage] ?? "ru")
    }
    
    func toggleLanguage() {
        
        if let currentIndex = availableLanguages.firstIndex(of: selectedLanguage) {
            let nextIndex = (currentIndex + 1) % availableLanguages.count
            let newLanguage = availableLanguages[nextIndex]
            
            let languageCode = languageMap[newLanguage] ?? "UNKNOWN"
            
            withAnimation {
                storedLanguage = languageMap[newLanguage] ?? "ru"
                selectedLanguage = newLanguage
            }
            
            Bundle.setLanguage(languageCode)
            
        }
    }
    
    func localizedString(forKey key: String) -> String {
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            
            return NSLocalizedString(key, comment: "")
        }
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}


extension Bundle {
    private static var onLanguageDispatchOnce: () -> Void = {
        object_setClass(Bundle.main, PrivateBundle.self)
    }
    
    static func setLanguage(_ language: String) {
        onLanguageDispatchOnce()
        if let currentLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first, currentLanguage == language {
            return
        }
        
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}


private class PrivateBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}


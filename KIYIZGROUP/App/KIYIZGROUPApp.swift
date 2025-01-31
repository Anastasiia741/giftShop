//  GiftShopApp.swift
//  GiftShop
//  Created by Анастасия Набатова on 5/1/24.

import SwiftUI
import Firebase

let screen = UIScreen.main.bounds

@main
struct KIYIZGROUPApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var mainTabVM = MainTabVM()
    
    var body: some Scene {
        WindowGroup {
            TabBar(viewModel: mainTabVM)
                .environmentObject(mainTabVM)
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()
            
            return true
        }
    }
}

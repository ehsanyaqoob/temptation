//
//  temptationApp.swift
//  temptation
//
//  Created by ehsanyaqoob on 30/03/2026.
//

import SwiftUI
import Firebase

@main
struct temptationApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("firebase configured!!")
        return true
    }
}

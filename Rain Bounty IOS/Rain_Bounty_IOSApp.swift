//
//  Rain_Bounty_IOSApp.swift
//  Rain Bounty IOS
//
//  Created by Surya Swaminathan on 2/16/25.
//

import SwiftUI
import OneSignalFramework

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Verbose logging for testing/debugging rain logic
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        
        // Initialize OneSignal SDK
        // Replace with your 36-character UUID from the OneSignal Settings dashboard
        OneSignal.initialize("d298b3f4-e05e-413c-91b5-d188f8beae0e", withLaunchOptions: launchOptions)
        
        // Request push notification banner permission
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        return true
    }
}

@main
struct Rain_Bounty_IOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

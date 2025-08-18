//
//  AppDelegate.swift
//  iOS-Test
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let sessionService = Services.sessionTrackingService
    private let reviewService  = Services.reviewRequestService
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        reviewService.startMonitoring()
        sessionService.startSession()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}

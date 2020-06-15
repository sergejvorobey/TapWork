//
//  AppDelegate.swift
//  TapWork
//
//  Created by Sergey Vorobey on 10/01/2020.
//  Copyright © 2020 Сергей. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.red
        
        FirebaseApp.configure()
        
        checkUserLogin()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    
    // MARK: - HELPER METHODS
    
    func checkUserLogin() {
        // to check whether the user has already logged in or not
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            
            if user == nil {
                
                self?.goToLoginScreen()
                
            } else {
                
                self?.goToUserAccount()
                
            }
        }
    }
    
    func goToUserAccount () {
        print("User is login")
        
    }
    
    func goToLoginScreen () {
        print("User is not login")
        
    }
}

//
//  AppDelegate.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/11/23.
//

import UIKit
import FirebaseAuth
import Firebase
import Combine

class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
    @Published var isLoggedIn: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // Check if the user is already logged in
        isLoggedIn = Auth.auth().currentUser != nil
        
        return true
    }
}

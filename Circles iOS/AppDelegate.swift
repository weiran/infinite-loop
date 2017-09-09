//
//  AppDelegate.swift
//  Circles iOS
//
//  Created by Weiran Zhang on 15/11/2015.
//  Copyright © 2015 Weiran Zhang. All rights reserved.
//

import UIKit
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // authenticate with Game Center
        if GKLocalPlayer.localPlayer().isAuthenticated == false {
            GKLocalPlayer.localPlayer().authenticateHandler = { (view, error) in
                if let _error = error {
                    print("Game Center Authentication Error: \(_error.localizedDescription)")
                }
            }
        }
        
        return true
    }
}

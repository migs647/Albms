//
//  AppDelegate.swift
//  Albms
//
//  Created by Cody Garvin on 5/6/19.
//  Copyright © 2019 Cody Garvin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: AlbmsDataController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Start up the data controller for core data
        dataController = AlbmsDataController(completionClosure: nil)
        
        // Build up the theme that will be used throughout the entire app
        buildTheme()
        return true
    }

    func buildTheme() {
        
        self.window?.tintColor = UIColor.albDarkGray()
        
        UINavigationBar.appearance().barTintColor = UIColor.albDarkGray()
        UINavigationBar.appearance().tintColor = UIColor.albPollution()
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.albPollution()]
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.albPollution()]
        
        UITableView.appearance().separatorColor = UIColor.albDarkGray()
        UITableView.appearance().backgroundColor = UIColor.albDarkBackground()
    }
}


//
//  AppDelegate.swift
//  lime
//
//  Created by dzzhang on 2023/2/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = nil;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.frame(forAlignmentRect: UIScreen.main.bounds)
        self.window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        return true
    }


}


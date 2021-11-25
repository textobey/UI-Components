//
//  AppDelegate.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        window.rootViewController = MainViewController()
        window.makeKeyAndVisible()
        return true
    }
}


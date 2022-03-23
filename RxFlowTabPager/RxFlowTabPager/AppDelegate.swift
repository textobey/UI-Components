//
//  AppDelegate.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()

        return true
    }
}


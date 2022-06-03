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
      
        let navigationController = UINavigationController(rootViewController: MainViewController()).then {
            $0.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.isTranslucent = true
            $0.view.backgroundColor = UIColor.clear
            $0.navigationBar.backgroundColor = UIColor.clear
            $0.setNavigationBarHidden(true, animated: false)
        }
      
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return true
    }
}


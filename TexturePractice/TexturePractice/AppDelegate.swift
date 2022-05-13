//
//  AppDelegate.swift
//  TexturePractice
//
//  Created by 이서준 on 2022/04/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        window.makeKeyAndVisible()
        window.backgroundColor = .systemBackground
        window.rootViewController = VideoFeedViewController()
        return true
    }
}


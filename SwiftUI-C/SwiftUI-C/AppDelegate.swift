//
//  AppDelegate.swift
//  SwiftUI-C
//
//  Created by 이서준 on 2021/10/05.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = window else { return false }
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        // Use a UIHostingController as window root view controller.
        window.rootViewController = UIHostingController(rootView: contentView)
        window.makeKeyAndVisible()

        return true
    }
}


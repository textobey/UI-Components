//
//  NavigationControlManager.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import UIKit

class NavigationControlManager {
    static let `shared` = NavigationControlManager()
    let currentNavigationController: UINavigationController?
    
    private init() {
        self.currentNavigationController = UIApplication.topViewController()?.children.first as? UINavigationController
    }
    
    func popCurrentView(animated: Bool = true) {
        currentNavigationController?.popViewController(animated: animated)
    }
    
    func popToRootView(animated: Bool = true) {
        currentNavigationController?.popToRootViewController(animated: animated)
    }
    
    func dismissCurrentView(animated: Bool = true) {
        currentNavigationController?.dismiss(animated: animated)
    }
}

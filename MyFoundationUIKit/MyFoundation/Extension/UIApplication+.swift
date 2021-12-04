//
//  UIApplication+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/03.
//

import UIKit

extension UIApplication {
    public var topViewController: UIViewController? {
        return UIApplication.getTopViewController()
    }
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

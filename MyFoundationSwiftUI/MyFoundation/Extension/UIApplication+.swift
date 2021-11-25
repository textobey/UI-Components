//
//  UIApplication+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import UIKit

extension UIApplication {
    /// keyWindow의 rootViewController를 통해서 현재 화면 스택상 가장 최상단에 위치한 ViewController를 얻음
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

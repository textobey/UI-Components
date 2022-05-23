//
//  UIWindow+.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/20.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        let foundKeyWindow: UIWindow?
        if #available(iOS 15, *) {
            let windows = (UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene)?.windows
            foundKeyWindow = windows?.first { $0.isKeyWindow } ?? windows?.first { $0.canBecomeKey }
        } else if #available(iOS 13, *) {
            foundKeyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            foundKeyWindow = UIApplication.shared.keyWindow
        }
        return foundKeyWindow
    }
    
    static var keySafeAreaInsets: UIEdgeInsets {
        return key?.safeAreaInsets ?? UIEdgeInsets()
    }
    
    static let statusBarHeight: CGFloat = {
        if #available(iOS 13.0, *) {
            return UIWindow.key?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        } else {
            return 20
        }
    }()
}

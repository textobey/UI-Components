//
//  UIColor+.swift
//  RxFlowTabPager
//
//  Created by 이서준 on 2022/03/24.
//

import UIKit

extension UIColor {
    class var tabmanPrimary: UIColor {
        UIColor(red: 0.56, green: 0.18, blue: 0.89, alpha: 1.00)
    }
    
    class var tabmanSecondary: UIColor {
        UIColor(red: 0.29, green: 0.00, blue: 0.88, alpha: 1.00)
    }
    
    class var tabmanForeground: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .white
                default:
                    return UIColor(red: 0.56, green: 0.18, blue: 0.89, alpha: 1.00)
                }
            }
        } else {
            return UIColor(red: 0.56, green: 0.18, blue: 0.89, alpha: 1.00)
        }
    }
}


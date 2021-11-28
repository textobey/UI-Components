//
//  UIFont+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit

extension UIFont {
    enum NotoSansStyle: String {
        case regular = "NotoSansKR-Regular"
        case medium = "NotoSansKR-Medium"
        case bold = "NotoSansKR-Bold"
    }
    enum MontserratStyle: String {
        case regular = "Montserrat-Regular"
        case medium = "Montserrat-Medium"
        case bold = "Montserrat-Bold"
    }
    static func notoSans(size: CGFloat, style: NotoSansStyle = .regular) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
    static func montserrat(size: CGFloat, style: MontserratStyle = .regular) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}

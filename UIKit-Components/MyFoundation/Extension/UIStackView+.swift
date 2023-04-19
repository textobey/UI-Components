//
//  UIStackView+.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/05/18.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}

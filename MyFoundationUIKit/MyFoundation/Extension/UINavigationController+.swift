//
//  UINavigationController+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // if viewStackCount > 1, enable to Swipe Back
        return viewControllers.count > 1
    }
}

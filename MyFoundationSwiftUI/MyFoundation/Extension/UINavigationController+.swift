//
//  UINavigationController+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/19.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Swipe Back 제스쳐 가능여부는 delegate Method의 return값 따라감
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // view Stack이 1개보다 많을 때, Swipe Back 제스쳐 가능
        return viewControllers.count > 1
    }
}

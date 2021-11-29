//
//  UIView+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxCocoa

extension UIView {
    public func tapGesture() -> ControlEvent<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        return tapGesture.rx.event
    }
}

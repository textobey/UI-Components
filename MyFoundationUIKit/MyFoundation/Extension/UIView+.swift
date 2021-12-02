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
    /// infinite rotate
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    func animate(transform: CGAffineTransform, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = transform
        }
    }
}

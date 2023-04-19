//
//  UIAlertController+.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/03.
//

import UIKit

extension UIAlertController {
    /// UIAlertController 버그로 인한 debugDescription을 포함하고 있으면, 해당 제약조건은 제거함
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

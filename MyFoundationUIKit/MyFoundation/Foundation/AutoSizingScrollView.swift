//
//  AutoSizingScrollView.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit

class AutoSizingScrollView: UIScrollView {
    var maximumHeight: CGFloat = 1500
    
    override var contentSize: CGSize {
        didSet {
            if let heightConstraint = constraints.first(where: { $0.firstAttribute == .height }) {
                heightConstraint.constant = min(maximumHeight, contentSize.height)
            } else {
                let rect = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: min(maximumHeight, frame.height))
                frame = rect
            }
        }
    }
}

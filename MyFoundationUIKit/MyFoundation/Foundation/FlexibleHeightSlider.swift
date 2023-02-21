//
//  FlexibleHeightSlider.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/02/21.
//

import UIKit

class FlexibleHeightSlider: UISlider {
    
    let height: CGFloat
    
    init(height: CGFloat = 8) {
        self.height = height
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: self.height))
    }
}

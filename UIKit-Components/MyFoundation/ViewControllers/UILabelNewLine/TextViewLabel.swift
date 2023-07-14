//
//  TextViewLabel.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/07/14.
//

import UIKit

// a replacement for UILabel
// but, it's okay to use UILabel.
class TextViewLabel: UITextView {
    
    public var numberOfLines: Int = 0 {
        didSet {
            textContainer.maximumNumberOfLines = numberOfLines
        }
    }
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            textContainer.lineBreakMode = lineBreakMode
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() -> Void {
        isScrollEnabled = false
        isEditable = false
        isSelectable = false
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
    
}

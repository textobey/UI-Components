//
//  DynamicHeightTableView.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/30.
//

import UIKit

/// UIButton, UILabel처럼 Content를 바탕으로 본질적인 사이즈를 가지는 TableView.
///
/// 보통 TableView는 Height 제약조건이 필수지만, 위의 설명처럼 컨텐츠를 바탕으로 사이즈를 가지기 때문에 높이를 지정하지 않아도 됩니다.
/// 단, Height가 ContentSize보다 작아지는것은 방지해야하기 때문에 greaterThanOrEqualTo(tableView.contentSize.height)로 조건을 지정해야합니다.
class DynamicHeightTableView: UITableView {
    var isDynamicSizeRequired = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != self.intrinsicContentSize {
            if self.intrinsicContentSize.height > frame.size.height {
                self.invalidateIntrinsicContentSize()
            }
        }
        if isDynamicSizeRequired {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

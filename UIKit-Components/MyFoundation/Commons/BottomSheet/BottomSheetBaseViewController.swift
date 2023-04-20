//
//  BottomSheetBaseViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/20.
//

import Foundation

class BottomSheetBaseViewController: UIBaseViewController {
    
    static var titleRectHeight: CGFloat = 80

    weak var sendDelegate: BottomSheetSendDelegate?

    let contentView: BottomSheetBaseView

    let contentTitle: String
    
    init(title: String?, contentView: BottomSheetBaseView) {
        self.contentView = contentView
        self.contentTitle = title ?? .empty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol BottomSheetSendDelegate: AnyObject {
    func sendPartialSheetViewControllerAction(action: BottomSheetBaseView.OutputActionType)
}

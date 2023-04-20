//
//  BottomSheetBaseView.swift
//  MyFoundation
//
//  Created by 이서준 on 2023/04/20.
//

import UIKit
import RxSwift
import RxCocoa

class BottomSheetBaseView: UIView {
    
    var outputRelay = PublishRelay<OutputActionType>()
    
    // for get
    private(set) var _scrollView = UIScrollView()

    var dataSources: [Any] = [] {
        didSet {
            updateLayout()
        }
    }

    func updateLayout() {
    }

    enum OutputActionType {
        case dismiss
        case updateOriginY(CGFloat)
        case button(Any? = nil)
        //case other..
    }
}

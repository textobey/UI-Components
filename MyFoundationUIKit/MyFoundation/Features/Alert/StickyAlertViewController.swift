//
//  StickyAlertViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/14.
//

import UIKit

class StickyAlertViewController: UIBaseViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        setPresentType(type: .modal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

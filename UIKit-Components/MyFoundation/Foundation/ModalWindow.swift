//
//  ModalWindow.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/04/08.
//

import UIKit

class ModalWindow: UIWindow {
    let mainViewController = UIViewController().then {
        $0.view.backgroundColor = .clear
    }
    
    convenience init(windowLevel: UIWindow.Level? = nil) {
        self.init(frame: UIScreen.main.bounds)
        if let windowLevel = windowLevel {
            self.windowLevel = windowLevel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = false
        super.rootViewController = mainViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(_ viewController: UIViewController, animated: Bool) {
        mainViewController.present(viewController, animated: animated)
    }
}

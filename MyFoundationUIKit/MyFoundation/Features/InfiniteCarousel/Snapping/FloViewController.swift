//
//  FloViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2022/10/13.
//

import UIKit

class FloViewController: UIBaseViewController {
    
    let horizontalController = FloHorizontalController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "AppStoreClone")
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(horizontalController.view)
        horizontalController.view.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()//.inset(11)
            $0.height.equalTo(calHorizontalHeight())
        }
    }
    
    private func calHorizontalHeight() -> CGFloat {
        return (view.bounds.width - 22) / 2
    }
}

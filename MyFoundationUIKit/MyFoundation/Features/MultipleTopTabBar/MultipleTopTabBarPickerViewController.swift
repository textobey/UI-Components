//
//  MultipleTopTabBar.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class MultipleTopTabBarViewController: UIBaseViewController {
    lazy var tempLabel = UILabel().then {
        $0.text = "MultipleTopTabBar"
        $0.textColor = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "MultipleTopTabBar")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(tempLabel)
        tempLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

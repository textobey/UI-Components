//
//  DropDownViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit

class DropDownViewController: UIBaseViewController {
    
    lazy var dropDownSelection = DropDownSelection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "DropDown")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(dropDownSelection)
        dropDownSelection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

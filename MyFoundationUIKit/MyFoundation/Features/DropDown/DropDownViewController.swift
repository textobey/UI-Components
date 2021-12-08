//
//  DropDownViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit

class DropDownViewController: UIBaseViewController {
    lazy var dropDownModel = DropDownInitComponent(dataSource: ["Apple", "Mango", "Orange"])
    
    lazy var dropDownSelection = DropDownSelection(model: dropDownModel).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        dropDownSelection.dropDownButton.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(44)
        }
    }
}

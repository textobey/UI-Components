//
//  DropDownViewController.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/12/01.
//

import UIKit

class DropDownViewController: UIBaseViewController {
    lazy var dropDownModel = DropDownInitComponent(dataSource: ["Apple", "Mango", "Orange"], isBorderStyle: true)
    
    lazy var dropDownSelection = DropDownSelection(model: dropDownModel).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "DropDown")
        setupLayout()
        bindRx()
    }
    
    private func setupLayout() {
        addSubview(dropDownSelection)
        dropDownSelection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        // 위치를 대략적으로 잡아놨기 때문에, 실제 구현하는곳에서 remakeConstraints로 원하는 제약조건으로 다시 지정해줘야함.
        dropDownSelection.dropDownButton.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(44)
        }
    }
    
    private func bindRx() {
        // viewController에서 처리해야할 dropdown 인터랙션은 여기서 처리해야할듯
    }
}

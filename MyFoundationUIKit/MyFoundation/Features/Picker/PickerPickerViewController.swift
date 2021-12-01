//
//  Picker.swift
//  MyFoundation
//
//  Created by 이서준 on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa

class PickerViewController: UIBaseViewController {
    lazy var pickerView = PickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(title: "Picker")
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(pickerView)
        pickerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
